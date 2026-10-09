//
//  StoryView.swift
//  MyApp
//
//  Created by Andre on 07/10/26.
//

import SwiftUI
import AVKit

enum StoryItem: Identifiable {
    case image(id: UUID, data: Data)
    case video(id: UUID, url: URL)

    var id: UUID {
        switch self {
        case .image(let id, _), .video(let id, _): id
        }
    }
}

struct StoryView: View {
    let stories: [StoryItem]
    var onViewed: () -> Void = {}
    private let duracao = 3.0
    private let passo = 0.03
    @State var index = 0
    @State var progress = 0.0
    
    var body: some View {
        ZStack {
            if stories.indices.contains(index) {
                switch stories[index] {
                case .image(_, let data):
                    if let photo = UIImage(data: data) {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    } else {
                        Text("Não foi possível carregar esta foto")
                            .foregroundStyle(.secondary)
                    }
                case .video(_, let url):
                    StoryVideo(url: url, progress: $progress) {
                        storySuperior()
                    }
                    .id(stories[index].id)
                }
            } else {
                Text("Nenhum story disponível")
                    .foregroundStyle(.secondary)
            }
            HStack{
                Button{
                    storyAnterior()
                    
                }label: {
                    Rectangle()
                        .frame(width: 200,height: .infinity)
                        .foregroundStyle(Color.clear)
                }
                Button{
                    storySuperior()
                }label: {
                    Rectangle()
                        .frame(width: 200,height: .infinity)
                        .foregroundStyle(Color.clear)
                }
                
            }
        }
        .task(id: index) {
            await rodarStory()
        }
        .onAppear(perform: onViewed)
        .toolbar(.hidden,for:.tabBar)
        .toolbar {
            ForEach(stories.indices, id: \.self) { i in
                ProgressView(value: valorBarra(para: i))
                    .tint(.white)
            }
        }
    }
    func storyAnterior() {
        if index == 0{
            return
        }else{
            progress -= 0.2
            index -= 1
        }
    }
    //    func executarStoryporTempo(){
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
    //
    //        }
    
    func storySuperior(){
        if index >= stories.count - 1{
            return
        }else{
            progress += 0.2
            index += 1
        }
    }
    
    func valorBarra(para i: Int) -> Double {
        if i < index { return 1 }
        if i == index { return progress }
        return 0
    }
    
    func rodarStory() async {
        guard !stories.isEmpty else { return }
        if case .video = stories[index] { return }
        progress = 0
        let incremento = passo / duracao
        
        while progress < 1 {
            do {
                try await Task.sleep(for: .seconds(passo))
            } catch {
                return
            }
            progress += incremento
        }
        
        storySuperior()
    }
}

private struct StoryVideo: View {
    let url: URL
    @Binding var progress: Double
    var onPlaybackEnded: () -> Void
    @State private var player: AVPlayer?
    @State private var endObserver: NSObjectProtocol?
    @State private var progressObserver: Any?

    var body: some View {
        Group {
            if let player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            let item = AVPlayerItem(url: url)
            let videoPlayer = AVPlayer(playerItem: item)
            player = videoPlayer
            endObserver = NotificationCenter.default.addObserver(
                forName: AVPlayerItem.didPlayToEndTimeNotification,
                object: item,
                queue: .main
            ) { _ in
                progress = 1
                onPlaybackEnded()
            }
            progressObserver = videoPlayer.addPeriodicTimeObserver(
                forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
                queue: .main
            ) { time in
                let duration = item.duration.seconds
                guard duration.isFinite, duration > 0 else { return }
                progress = min(max(time.seconds / duration, 0), 1)
            }
            videoPlayer.play()
        }
        .onDisappear {
            player?.pause()
            if let endObserver {
                NotificationCenter.default.removeObserver(endObserver)
            }
            if let progressObserver, let player {
                player.removeTimeObserver(progressObserver)
            }
        }
    }
}

