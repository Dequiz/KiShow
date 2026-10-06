import SwiftUI
import SwiftData
import AVKit

enum AppTheme: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case fotos = "Fotos"
    case videos = "Vídeos"
    case audios = "Audios"

    var id: String { rawValue }
}

struct EventView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \ExperienceEntity.idExperience) var experiences: [ExperienceEntity]
    @State var selected = AppTheme.todos
    @State var player = MiniPlayer()
   static var show = ShowEntity(nameShow: "Bts", dataShow: Date(), artistShow: "BTS", genderShow: "K-pop", imageShow: "data:image/jpeg;base64,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", localShow: "Senac", addressShow: "Senac - 120", urlShow: "apple.com", startTimeShow: "12:00", city: "São Paulo")
    static var eventoSelecionado = EventEntity(show: show)
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
                                VinylRecord(
                                    fullVynil: 100,
                                    urlMusic: URL(string: EventView.eventoSelecionado.show!.imageShow)!
                                )
                                Text(EventView.eventoSelecionado.show!.nameShow)
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
                                    Button("Excluir", role: .destructive) {
                                        delete(experience)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(destination: AddExperience()) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    @ViewBuilder
    private func row(for experience: ExperienceEntity) -> some View {
        switch experience.type {
        case .image:
            VStack {
                if let data = experience.imageContent?.first,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(height: 200)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                if let text = experience.textContent, !text.isEmpty {
                    Text(text)
                }
            }

        case .video:
            VStack {
                if let fileName = experience.videoContent?.first {
                    VideoCard(fileName: fileName)
                        .padding(.horizontal)
                }
                if let text = experience.textContent, !text.isEmpty {
                    Text(text)
                }
            }

        case .text:
            Text(experience.textContent ?? "")

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
                                Image(systemName:player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .foregroundColor(.white)
                            }
                            ProgressView(value: (player.currentAudioID == experience.idExperience) ? player.progress : 0.0)
                                .progressViewStyle(.linear)
                                .tint(.white)
                                .padding(.leading, 8)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        .frame(width: 200)
                    }
                    
                    if let text = experience.textContent, !text.isEmpty {
                        Text(text)
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
                    .frame(height: 250)
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
