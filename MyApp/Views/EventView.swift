import SwiftUI
import SwiftData
import AVKit
import SimpleToast
import TipKit
import AVFoundation

enum AppTheme: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case fotos = "Fotos"
    case videos = "Vídeos"
    case audios = "Audios"

    var id: String { rawValue }
}

struct EventView: View {
    
   
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context
    @State private var showToast = false
    @State private var calendarToastMessage = ""
    @State private var calendarToastSucceeded = false
    @State private var isAddingToCalendar = false
    private let toastOption = SimpleToastOptions(alignment: .top,hideAfter: 2,backdrop: Color.black.opacity(0.2),animation: .default,modifierType: .slide)

    private var experiences: [ExperienceEntity] {
        (eventoSelecionado.experiences ?? [])
              .sorted { $0.idExperience.uuidString < $1.idExperience.uuidString }
      }
    let manager = CalendarManager()
    @State var selected = AppTheme.todos
    @State var player = MiniPlayer()
    @State var eventoSelecionado: EventEntity
    @State private var dailyStories: [StoryItem] = []
    @State private var hasUnseenStories = false
    @State private var experienceToEdit: ExperienceEntity?

    private var storyDateKey: String {
        let date = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return String(format: "%04d-%02d-%02d", date.year ?? 0, date.month ?? 0, date.day ?? 0)
    }

    private var storySelectionKey: String {
        "daily-stories.\(eventoSelecionado.idEvent.uuidString).\(storyDateKey)"
    }

    private var storyViewedKey: String {
        "daily-stories-viewed.\(eventoSelecionado.idEvent.uuidString)"
    }

    private var filtered: [ExperienceEntity] {
        switch selected {
        case .todos:  return experiences
        case .fotos:  return experiences.filter { $0.type == .image }
        case .videos: return experiences.filter { $0.type == .video }
        case .audios: return experiences.filter { $0.type == .audio }
        }
    }

    private let favoritoTip = FavoritoTip()
    private let eventStoryTip = EventStoryTip()

    var body: some View {
        ZStack{
            Color("AppBackground")
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 10) {
                    VStack() {
                        NavigationLink(destination: StoryView(stories: dailyStories) {
                            markDailyStoriesAsViewed()
                        }) {
                            VinylRecord(
                                isTurning: hasUnseenStories,
                                isGoingUp: hasUnseenStories,
                                fullVynil: 150,
                                image: eventoSelecionado.show?.imageShow
                                    .flatMap { UIImage(data: $0) }
                                    .map(Image.init(uiImage:))
                            )
                            .popoverTip(eventStoryTip, arrowEdge: .top)
                            .tipViewStyle(CenteredTipViewStyle())
                            .disabled(true)
                        }
                        .disabled(dailyStories.isEmpty)
                        
                        Spacer()

                        Text(eventoSelecionado.show?.nameShow ?? "Evento")
                            .font(.body)
                            .fontWeight(.bold)
                        
                        Spacer()

                        ColapsedList(eventoSelecionado: eventoSelecionado)

                        if #available(iOS 27.0, *) {
                            themePicker
                                .pickerStyle(.tabs)
                                .glassEffect()
                        } else {
                            themePicker
                                .pickerStyle(.segmented)
                                .glassEffect()
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background {
                            Image(.camada1)
                                .resizable()
                                .frame(maxHeight: 600)
                                .frame(minHeight: 400)
                                .clipped()
                                .opacity(0.3)
                                .scaledToFill()
                    }

                    Spacer()
                    if filtered.isEmpty {
                        emptyMediaPlaceholder
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(filtered) { experience in
                                row(for: experience)
                                    .padding(.top)
                                    .contextMenu {
                                        Button("Editar", systemImage: "pencil") {
                                            experienceToEdit = experience
                                        }
                                        .tint(.primary)
                                        Button("Excluir",systemImage: "trash.fill", role: .destructive) {
                                            delete(experience)
                                        }
                                        .tint(.primary)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOption, content: {
            HStack(spacing: 10) {
                Image(systemName: calendarToastSucceeded ? "calendar.badge.checkmark" : "calendar")
                    .font(.callout)
                Text(calendarToastMessage)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .background(calendarToastSucceeded ? Color.mainPurple : Color.red)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .frame(maxWidth: 360)
            .padding(.horizontal, 16)
        })
        
        .onDisappear(){
            player.stop()
        }
        .onAppear(perform: refreshDailyStories)
        .onChange(of: experiences.count) { _, _ in
            refreshDailyStories()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                refreshDailyStories()
            }
        }
       
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink(destination: AddExperience(eventoSelecionado: eventoSelecionado)) {
                    Image(systemName: "plus")
                }
                .tint(.primary)
                .popoverTip(favoritoTip, arrowEdge: .top)
                .tipViewStyle(CenteredTipViewStyle())
                Button {
                    guard !isAddingToCalendar else { return }
                    let nomeShow = eventoSelecionado.show?.nameShow ?? "Show"
                    let dateShow = eventoSelecionado.show?.dataShow ?? Date()
                    let title = "Show do: \(nomeShow)"
                    isAddingToCalendar = true
                    Task {
                        let result = await manager.criarCompromisso(
                            titulo: title,
                            dataInicio: dateShow,
                            dataFim: dateShow
                        )
                        switch result {
                        case .added:
                            calendarToastMessage = "Show: \(nomeShow) foi adicionado ao calendário."
                            calendarToastSucceeded = true
                        case .alreadyExists:
                            calendarToastMessage = "Show: \(nomeShow) já está no calendário."
                            calendarToastSucceeded = false
                        case .accessDenied:
                            calendarToastMessage = "Sem permissão para acessar o calendário."
                            calendarToastSucceeded = false
                        case .failed(let message):
                            calendarToastMessage = "Não foi possível adicionar o show: \(message)"
                            calendarToastSucceeded = false
                        }
                        isAddingToCalendar = false
                        showToast = true
                    }
                } label: {
                    if isAddingToCalendar {
                        ProgressView()
                    } else {
                        Image(systemName: "calendar.badge.plus")
                    }
                }
                .disabled(isAddingToCalendar)
                .tint(.primary)
                .accessibilityLabel("Adicionar show ao calendário")
            }
        }
        .sheet(item: $experienceToEdit) { experience in
            NavigationStack {
                AddExperience(
                    eventoSelecionado: eventoSelecionado,
                    experienceToEdit: experience
                )
            }
        }
    }

    private var themePicker: some View {
        Picker("", selection: $selected) {
            ForEach(AppTheme.allCases) { tipo in
                Text(tipo.rawValue).tag(tipo)
            }
        }
        .frame(maxWidth: 350)
        .controlSize(.large)
    }

    private var emptyMediaPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: experiences.isEmpty ? "photo.on.rectangle.angled" : "tray")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)

            Text(experiences.isEmpty ? "Nenhuma mídia adicionada" : "Nenhuma mídia nesta categoria")
                .font(.headline)
                .foregroundStyle(.primary)

            if experiences.isEmpty {
                Text("Toque em + para guardar \numa lembrança deste show.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 48)
        .accessibilityElement(children: .combine)
    }

    private func refreshDailyStories() {
        let availableStories: [StoryItem] = experiences.compactMap { experience in
            switch experience.type {
            case .image:
                guard let data = experience.imageContent?.first, !data.isEmpty else { return nil }
                return .image(id: experience.idExperience, data: data)
            case .video:
                guard let fileName = experience.videoContent?.first else { return nil }
                let url = URL.documentsDirectory.appending(path: fileName)
                guard FileManager.default.fileExists(atPath: url.path) else { return nil }
                return .video(id: experience.idExperience, url: url)
            case .audio, .text:
                return nil
            }
        }

        let defaults = UserDefaults.standard
        let storiesByID = Dictionary(uniqueKeysWithValues: availableStories.map { ($0.id.uuidString, $0) })
        if let savedIDs = defaults.stringArray(forKey: storySelectionKey), !savedIDs.isEmpty {
            var selectedStories = Array(savedIDs.prefix(5)).compactMap { storiesByID[$0] }
            let selectedIDSet = Set(selectedStories.map(\.id))
            let remainingStories = availableStories
                .filter { !selectedIDSet.contains($0.id) }
                .shuffled()
                .prefix(5 - selectedStories.count)
            selectedStories.append(contentsOf: remainingStories)
            dailyStories = selectedStories
            defaults.set(dailyStories.map { $0.id.uuidString }, forKey: storySelectionKey)
        } else {
            let photos = availableStories.filter {
                if case .image = $0 { return true }
                return false
            }.shuffled()
            let videos = availableStories.filter {
                if case .video = $0 { return true }
                return false
            }.shuffled()

            var selection: [StoryItem] = []
            if let photo = photos.first { selection.append(photo) }
            if let video = videos.first { selection.append(video) }
            let selectedIDs = Set(selection.map(\.id))
            let remaining = (photos + videos)
                .filter { !selectedIDs.contains($0.id) }
                .shuffled()
            selection.append(contentsOf: remaining.prefix(5 - selection.count))
            dailyStories = selection.shuffled()
            defaults.set(dailyStories.map { $0.id.uuidString }, forKey: storySelectionKey)
        }

        hasUnseenStories = !dailyStories.isEmpty && defaults.string(forKey: storyViewedKey) != storyDateKey
    }

    private func markDailyStoriesAsViewed() {
        UserDefaults.standard.set(storyDateKey, forKey: storyViewedKey)
        hasUnseenStories = false
    }

    

    @ViewBuilder
    private func row(for experience: ExperienceEntity) -> some View {
        var dataFormatada: String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "pt_BR")
            formatter.dateFormat = "MMM dd, yyyy 'as' HH'h'mm"
            return formatter.string(from: experience.timeStamp)
        }

        switch experience.type {
        case .image:
                VStack (spacing:10){
                    if let data = experience.imageContent?.first,
                       let uiImage = UIImage(data: data) {
                        var vertical : Bool {
                            return uiImage.size.height > uiImage.size.width
                        }
                        Image(uiImage: uiImage)
                            .resizable()
                            .clipped()
                            .clipShape(.rect(topLeadingRadius: 25, topTrailingRadius: 25))
                            .overlay(alignment: .topLeading){
                                Spacer()
                                HStack{
                                    Text("Última modificação:")
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                        .lineLimit(1)
                                    
                                    Text(dataFormatada)
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                        .lineLimit(1)
                                }
                                .padding(5)
                                .glassEffect()
                                .padding(.vertical,10)
                                .padding(.horizontal,10)
                                Spacer()
                            }
                            .scaledToFill()
                    }
                    if let text = experience.textContent, !text.isEmpty {
                        Text(text.first ?? "Vazio")
                            .padding()
                            .frame(minHeight: 50)
                            .frame(maxWidth: 370,maxHeight: 500)
                            .background(Color.details)
                            .padding(.top,0)
                            .clipShape(.rect(bottomLeadingRadius:25, bottomTrailingRadius: 25))
                            .offset(y:-10)
                    }
                    
                }

        case .video:
            VStack(spacing: 10){
                if let fileName = experience.videoContent?.first {
                    VideoCard(fileName: fileName)
                        .scaledToFill()
                        .clipped()
                        .frame(maxWidth: 370, maxHeight: 230)
                        .clipShape(.rect(topLeadingRadius: 25, topTrailingRadius: 25))
                        .padding(.bottom,0)
                        .overlay(alignment: .topLeading){
                            Spacer()
                            HStack{
                                Text("Última modificação:")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                                    .lineLimit(1)
                                
                                Text(dataFormatada)
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                                    .lineLimit(1)
                            }
                            .padding(5)
                            .glassEffect()
                            .padding(.vertical,10)
                            .padding(.horizontal,10)
                            Spacer()
                        }
                }
                if let text = experience.textContent, !text.isEmpty {
                    Text(text.first ?? "Vazio")
                        .frame(minHeight: 50)
                        .frame(maxWidth: 370,maxHeight: 230)
                        .background(Color.details)
                        .clipShape(.rect(bottomLeadingRadius:25, bottomTrailingRadius: 25))
                        .offset(y:-10)
                }
            }

        case .text:
            VStack(alignment: .leading){
                HStack{
                    Text("Última modificação:")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                    
                    Text(dataFormatada)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text(experience.textContent?.first ?? "Vazio")
            }
            .padding()
            .frame(minHeight: 50)
            .frame(maxWidth: 370)
            .background(Color.details)
            .clipShape(RoundedRectangle(cornerRadius: 25))

        case .audio:
            VStack{
                Spacer()
                HStack{
                    Text("Última modificação:")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                    
                    Text(dataFormatada)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                }
                Spacer()
                if let audioData = experience.audioContent?.first {
                    HStack{
                        Button {
                            if player.currentAudioID == experience.idExperience && player.isPlaying {
                                player.pause()
                            } else {
                                player.play(data: audioData, id: experience.idExperience)
                            }
                        } label: {
                            Image(systemName: player.currentAudioID == experience.idExperience && player.isPlaying
                                  ? "pause.circle.fill"
                                  : "play.circle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                        ProgressView(value: (player.currentAudioID == experience.idExperience) ? player.progress : 0.0)
                            .progressViewStyle(.linear)
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.trailing)
                    }
                   
                    Divider()
                        .background(Color.black)
                        .frame(maxWidth: 330)
                    if let text = experience.textContent, !text.isEmpty {
                        Text(text.first ?? "Vazio")
                            .padding()
                    }
                }
            }
            .frame(minHeight: 50)
            .frame(maxWidth: 370,maxHeight: 230)
            .background(Color.details)
        .clipShape(RoundedRectangle(cornerRadius: 25))
         
            }
    }

    private func delete(_ experience: ExperienceEntity) {
        if experience.type == .video, let fileName = experience.videoContent?.first {
            let url = URL.documentsDirectory.appending(path: fileName)
            try? FileManager.default.removeItem(at: url)
        }
        context.delete(experience)
    }
}

#if DEBUG

// MARK: - Mock (somente preview)

fileprivate enum MockKind {
    case image, video, audio, text
}

@MainActor
fileprivate enum EventMock {

    static func populate(_ context: ModelContext, kinds: Set<MockKind>) async -> EventEntity {
        let show = ShowEntity(
            nameShow: "The Weeknd - After Hours Til Dawn",
            dataShow: Calendar.current.date(byAdding: .day, value: 30, to: .now) ?? .now,
            artistShow: "The Weeknd",
            genderShow: "R&B",
            imageShow: placeholderImage(color: .systemPurple),
            localShow: "Allianz Parque",
            addressShow: "Av. Francisco Matarazzo, 1705 - Água Branca",
            urlShow: "https://www.ticketmaster.com.br",
            startTimeShow: "21:00",
            city: "São Paulo",
            latitude: -23.5275,
            longitude: -46.6783
        )

        let event = EventEntity(show: show, ticketThemeRawValue: "Purple")
        context.insert(event)

        if kinds.contains(.image), let data = placeholderImage(color: .systemPink) {
            context.insert(ExperienceEntity(
                type: .image,
                event: event,
                timeStamp: Date(),
                textContent: ["Que noite!"],
                imageContent: [data]
            ))
        }

        if kinds.contains(.video), let fileName = await MockVideo.makeFile() {
            context.insert(ExperienceEntity(
                type: .video,
                event: event,
                timeStamp: Date(),
                textContent: ["Todo mundo cantando junto"],
                videoContent: [fileName]
            ))
        }

        if kinds.contains(.audio) {
            let audio = MockAudio.loadFromBundle(name: "pequena-sereia")
                ?? MockAudio.makeWAV()
            context.insert(ExperienceEntity(
                type: .audio,
                event: event,
                timeStamp: Date(),
                textContent: ["Gravei esse trecho da música"],
                audioContent: [audio]
            ))
        }

        if kinds.contains(.text) {
            context.insert(ExperienceEntity(
                type: .text,
                event: event,
                timeStamp: Date(),
                textContent: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus lacinia ultricies semper. Suspendisse pharetra magna magna, tincidunt tempor lacus maximus molestie. Curabitur dolor arcu, suscipit sit amet neque ac, malesuada faucibus neque. Vestibulum consectetur tortor ut dui tristique eleifend. Cras vel mi nec lacus condimentum bibendum fringilla ac metus. Nulla volutpat, tortor et tempor tempor, felis diam gravida ligula, vehicula condimentum dui tortor ut nulla. Vestibulum ut sapien lectus. Pellentesque rhoncus sem tellus, a finibus metus vestibulum vitae. Integer non luctus tellus. Phasellus tristique sem sapien. Curabitur et justo placerat, imperdiet sem et, aliquam sem. Quisque non eros vitae leo ultrices malesuada eu eget quam. Quisque porta dictum diam vel malesuada. Mauris vitae elit hendrerit felis laoreet lobortis. Nullam fermentum nunc et arcu rutrum, sit amet sagittis turpis luctus."]
            ))
        }

        return event
    }

    static func placeholderImage(color: UIColor) -> Data? {
        let size = CGSize(width: 600, height: 600)
        let image = UIGraphicsImageRenderer(size: size).image { ctx in
            let colors = [color.cgColor, UIColor.black.cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: colors,
                                      locations: [0, 1])!
            ctx.cgContext.drawLinearGradient(gradient,
                                             start: .zero,
                                             end: CGPoint(x: size.width, y: size.height),
                                             options: [])
        }
        return image.pngData()
    }
}

// Gera um .mp4 em Documents (o VideoCard lê de lá pelo nome do arquivo)
fileprivate enum MockVideo {
    static func makeFile(named fileName: String = "mock-show.mp4",
                         seconds: Int = 3) async -> String? {
        let url = URL.documentsDirectory.appending(path: fileName)
        if FileManager.default.fileExists(atPath: url.path) { return fileName }

        let size = CGSize(width: 640, height: 360)
        guard let writer = try? AVAssetWriter(outputURL: url, fileType: .mp4) else { return nil }

        let input = AVAssetWriterInput(mediaType: .video, outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: Int(size.width),
            AVVideoHeightKey: Int(size.height)
        ])
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: input,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
                kCVPixelBufferWidthKey as String: Int(size.width),
                kCVPixelBufferHeightKey as String: Int(size.height)
            ]
        )
        writer.add(input)
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)

        let fps: Int32 = 10
        let totalFrames = seconds * Int(fps)

        for frame in 0..<totalFrames {
            while !input.isReadyForMoreMediaData {
                try? await Task.sleep(nanoseconds: 10_000_000)
            }
            let hue = CGFloat(frame) / CGFloat(totalFrames)
            let color = UIColor(hue: hue, saturation: 0.7, brightness: 0.8, alpha: 1)
            guard let buffer = pixelBuffer(size: size, color: color) else { continue }
            adaptor.append(buffer, withPresentationTime: CMTime(value: CMTimeValue(frame), timescale: fps))
        }

        input.markAsFinished()
        await writer.finishWriting()
        return writer.status == .completed ? fileName : nil
    }

    private static func pixelBuffer(size: CGSize, color: UIColor) -> CVPixelBuffer? {
        var buffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault,
                            Int(size.width),
                            Int(size.height),
                            kCVPixelFormatType_32ARGB,
                            nil,
                            &buffer)
        guard let buffer else { return nil }

        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

        guard let ctx = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else { return nil }

        ctx.setFillColor(color.cgColor)
        ctx.fill(CGRect(origin: .zero, size: size))
        return buffer
    }
}

fileprivate enum MockAudio {

    /// Carrega um áudio que você adicionou ao projeto.
    static func loadFromBundle(name: String, ext: String = "mp3") -> Data? {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return nil }
        return try? Data(contentsOf: url)
    }

    /// WAV de 3s com um tom de 440 Hz (fallback)
    static func makeWAV(frequency: Double = 440,
                        seconds: Double = 3,
                        sampleRate: Int = 44_100) -> Data {
        let sampleCount = Int(Double(sampleRate) * seconds)
        let dataSize = UInt32(sampleCount * 2)

        var data = Data()
        func append<T: FixedWidthInteger>(_ value: T) {
            var little = value.littleEndian
            withUnsafeBytes(of: &little) { data.append(contentsOf: $0) }
        }

        data.append(contentsOf: Array("RIFF".utf8))
        append(36 + dataSize)
        data.append(contentsOf: Array("WAVE".utf8))
        data.append(contentsOf: Array("fmt ".utf8))
        append(UInt32(16))
        append(UInt16(1))
        append(UInt16(1))
        append(UInt32(sampleRate))
        append(UInt32(sampleRate * 2))
        append(UInt16(2))
        append(UInt16(16))
        data.append(contentsOf: Array("data".utf8))
        append(dataSize)

        for i in 0..<sampleCount {
            let t = Double(i) / Double(sampleRate)
            let value = sin(2 * .pi * frequency * t) * 0.3 * Double(Int16.max)
            append(Int16(value))
        }
        return data
    }
}

// Host que monta o container em memória e popula o evento
fileprivate struct EventPreviewHost: View {
    let kinds: Set<MockKind>

    @State private var container = try! ModelContainer(
        for: EventEntity.self, ShowEntity.self, ExperienceEntity.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    @State private var event: EventEntity?

    var body: some View {
        NavigationStack {
            if let event {
                EventView(eventoSelecionado: event)
            } else {
                ProgressView()
            }
        }
        .modelContainer(container)
        .task {
            guard event == nil else { return }
            event = await EventMock.populate(container.mainContext, kinds: kinds)
        }
    }
}

// MARK: - Previews

#Preview("Todos") {
    EventPreviewHost(kinds: [.image, .video, .audio, .text])
}

#Preview("Foto") {
    EventPreviewHost(kinds: [.image])
}

#Preview("Vídeo") {
    EventPreviewHost(kinds: [.video])
}

#Preview("Áudio") {
    EventPreviewHost(kinds: [.audio])
}

#Preview("Vazio") {
    EventPreviewHost(kinds: [])
}

#endif

struct VideoCard: View {
    let fileName: String
    @State private var player: AVPlayer?

    var body: some View {
        Group {
            if let player {
                VideoPlayer(player: player)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text("Erro ao carregar o vídeo.")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            guard player == nil else { return }
            let url = URL.documentsDirectory.appending(path: fileName)
            if FileManager.default.fileExists(atPath: url.path) {
                player = AVPlayer(url: url)
            }
        }
        .onDisappear { player?.pause() }
    }
    
}
