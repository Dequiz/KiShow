//
//  MiniPlayer.swift
//  MyApp
//
//  Created by Andre on 05/10/26.
//

import Combine
import SwiftUI
import AVFoundation


@Observable
final class MiniPlayer{
    var isPlaying = false
    var progress: Double = 0
    var currentAudioID: UUID?
    private var player: AVAudioPlayer?
    private var timer: AnyCancellable?
    private var currentURL: URL?
    
    func play(_ url:URL?){
        guard let url else{return}
        if isPlaying, currentURL == url{
            pause()
            return
        }
        
        stop()
        
        do{
            try configureAudioSession()
            player = try AVAudioPlayer(contentsOf: url)
            currentURL = url
            
            player?.prepareToPlay()
            guard player?.play() == true else {
                throw PlaybackError.couldNotStart
            }
            isPlaying = true
            
            startUpdatingProgress()
        }
        catch{
            print("Playback failed: \(error)")
            isPlaying = false
        }
    }
    
    func pause(){
        player?.pause()
        isPlaying = false
        stopUpdatingProgress()
    }
    private func startUpdatingProgress(){
        stopUpdatingProgress()
        timer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink{
                [weak self] _ in
                guard let self, let player = self.player else {return}
                if player.isPlaying{
                    self.progress = player.duration > 0 ? player.currentTime / player.duration : 0
                } else{
                    self.isPlaying = false
                    self.stopUpdatingProgress()
                }
            }
    }
    
    private func stopUpdatingProgress(){
        timer?.cancel()
        timer = nil
    }
    
    func seek(to prog: Double){
        guard let player, player.duration > 0 else {return}
        player.currentTime = prog * player.duration
        progress = prog
    }
    
    var isPaused : Bool{
        player != nil && !isPlaying && progress > 0 && progress < 1
    }
    
    var playingURL : URL? {currentURL}
    
    func play(data: Data, id: UUID) {
            if isPlaying, currentAudioID == id {
                pause()
                return
            }
            
            stop()
            
            do {
                guard !data.isEmpty else { throw PlaybackError.emptyAudio }
                try configureAudioSession()
                player = try AVAudioPlayer(data: data)
                
                player?.prepareToPlay()
                guard player?.play() == true else {
                    throw PlaybackError.couldNotStart
                }
                currentAudioID = id
                isPlaying = true
                
                startUpdatingProgress()
            } catch {
                print("Playback failed: \(error)")
                isPlaying = false
                player = nil
                currentAudioID = nil
            }
        }

        private func configureAudioSession() throws {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        }

        private enum PlaybackError: Error {
            case emptyAudio
            case couldNotStart
        }
        
        func stop() {
            player?.stop()
            isPlaying = false
            progress = 0
            stopUpdatingProgress()
            player = nil
            currentURL = nil
            currentAudioID = nil
        }
}
