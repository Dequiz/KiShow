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
    @State var eventoSelecionado: EventEntity?
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
                                    urlMusic: URL(string: eventoSelecionado?.show?.imageShow ?? "Image 1")!
                                )
                                Text(eventoSelecionado?.show?.nameShow ?? "Evento")
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
