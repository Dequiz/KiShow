import SwiftUI
import SwiftData
import AVKit
import SimpleToast

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
    @State private var isShowingExperienceEditor = false

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

    var body: some View {
        ZStack{
            Color("AppBackground")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Image(.camada1)
                        .resizable()
                        .frame(width:500,height: 250)
                        .rotationEffect(.degrees(0))
                        .opacity(0.3)
                        .overlay(alignment: .bottom){
                            VStack{
                                NavigationLink(destination: StoryView(stories: dailyStories) {
                                    markDailyStoriesAsViewed()
                                }) {
                                    VinylRecord(
                                        isTurning: hasUnseenStories,
                                        isGoingUp: hasUnseenStories,
                                        fullVynil: 100,
                                        urlMusic: URL(string: eventoSelecionado.show?.imageShow ?? "Image 1")!
                                    )
                                    .disabled(true)
                                }
                                .disabled(dailyStories.isEmpty)
                               
                                Text(eventoSelecionado.show?.nameShow ?? "Evento")
                                Picker("", selection: $selected) {
                                    ForEach(AppTheme.allCases) { tipo in
                                        Text(tipo.rawValue).tag(tipo)
                                    }
                                }
                                .frame(width: 350)
                                .controlSize(.large)
                                .pickerStyle(.tabs)
                                .glassEffect() 
                            }
                            .padding(.horizontal)
                        }
                    Spacer()
                    LazyVStack(spacing: 30) {
                        ForEach(filtered) { experience in
                            row(for: experience)
                                .contextMenu {
                                    Button("Editar", systemImage: "pencil") {
                                        experienceToEdit = experience
                                        isShowingExperienceEditor = true
                                    }
                                    Button("Excluir",systemImage: "trash.fill", role: .destructive) {
                                        delete(experience)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
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
                        Image(systemName: "calendar")
                    }
                }
                .disabled(isAddingToCalendar)
                .accessibilityLabel("Adicionar show ao calendário")
            }
        }
        .sheet(isPresented: $isShowingExperienceEditor) {
            if let experienceToEdit {
                NavigationStack {
                    AddExperience(
                        eventoSelecionado: eventoSelecionado,
                        experienceToEdit: experienceToEdit
                    )
                }
            }
        }
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
        switch experience.type {
        case .image:
            VStack (spacing:10){
                if let data = experience.imageContent?.first,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 640, maxHeight: 420)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Divider()
                    .frame(maxWidth: 640)
                if let text = experience.textContent, !text.isEmpty {
                    Text(text.first ?? "Vazio")
                }
            }
            .padding()

        case .video:
            VStack(spacing: 10){
                if let fileName = experience.videoContent?.first {
                    VideoCard(fileName: fileName)
                        .frame(maxWidth: 640)
                        .frame(maxWidth: .infinity)
                }
                Divider()
                if let text = experience.textContent, !text.isEmpty {
                    Text(text.first ?? "Vazio")
                }
            }
            .padding()

        case .text:
            Text(experience.textContent?.first ?? "Vazio")
                .padding(.horizontal, 16)

        case .audio:
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
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .frame(maxWidth: 300)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                    }
                    
                    if let text = experience.textContent, !text.isEmpty {
                        Text(text.first ?? "Vazio")
                            .padding(.horizontal)
                    }
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


