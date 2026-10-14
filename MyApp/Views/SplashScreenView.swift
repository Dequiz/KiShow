//
//  SwiftUIView.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 13/10/26.
//

import SwiftUI
import AVKit

struct SplashScreenView: View {
    
    var onFinished: () -> Void
        @State private var player = AVPlayer(url: Bundle.main.url(forResource: "KiShow", withExtension: "mp4")!)

        var body: some View {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    player.play()
                    NotificationCenter.default.addObserver(
                        forName: AVPlayerItem.didPlayToEndTimeNotification,
                        object: player.currentItem,
                        queue: .main
                    ) { _ in
                        onFinished()
                    }
                }
        }
}
