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
                    VinylRecord(
                        fullVynil: 150,
                        urlMusic: URL(string: "https://http2.mlstatic.com/D_NQ_NP_2X_983699-MLA96154876825_102025-F.webp")!
                    )
                    
                    Picker("", selection: $selected) {
                        ForEach(AppTheme.allCases) { tipo in
                            Text(tipo.rawValue).tag(tipo)
                        }
                    }
                    .padding()
                    .pickerStyle(.tabs)
                    
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
            EmptyView()
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
