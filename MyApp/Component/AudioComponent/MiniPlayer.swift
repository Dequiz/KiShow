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
            player = try AVAudioPlayer(contentsOf: url)
            currentURL = url
            
            player?.prepareToPlay()
            player?.play()
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
                player = try AVAudioPlayer(data: data)
                currentAudioID = id
                
                player?.prepareToPlay()
                player?.play()
                isPlaying = true
                
                startUpdatingProgress()
            } catch {
                print("Playback failed: \(error)")
                isPlaying = false
            }
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
