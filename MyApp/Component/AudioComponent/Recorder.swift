//
//  Recorder.swift
//  MyApp
//
//  Created by Andre on 05/10/26.
//

import Combine
import AVFoundation

@Observable
final class Recorder{
    
    var isRecording = false
    var meterLevel: Float = 0
    var meterHistory: [Float] = []
    
    private var recorder: AVAudioRecorder?
    private var meterTimer: AnyCancellable?
    private(set) var fileURL: URL?
    
    func requestPermission(_ done: @escaping (Bool) -> Void){
        if #available(iOS 17.0, *){
            AVAudioApplication.requestRecordPermission{
                ok in
                DispatchQueue.main.async{
                    done(ok)
                }
            }
        }else{
            AVAudioSession.sharedInstance().requestRecordPermission{
                ok in
                DispatchQueue.main.async{
                    done(ok)
                }
            }
        }
    }
    
    func start(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord,mode: .default,options: [.defaultToSpeaker])
            try session.setActive(true)
            
            let dir = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("Recordings", isDirectory: true)
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            let stamp = ISO8601DateFormatter().string(from: .now).replacingOccurrences(of: ":", with: "-")
            let url = dir.appendingPathComponent("\(stamp).m4a")
            fileURL = url
            
            let settings: [String:Any] = [
                AVFormatIDKey : kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.record()
            isRecording = true
            
            startMetering()
        }
        catch{
            print("Startfailed: \(error)")
        }
    }
    private func startMetering(){
        meterTimer?.cancel()
        meterTimer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink{
                [weak self] _ in
                guard let self, let rec = self.recorder, rec.isRecording else{return}
                rec.updateMeters()
                
                let power = rec.averagePower(forChannel: 0)
                self.meterLevel = Self.normalize(power)
                self.meterHistory.append(self.meterLevel)
                if self.meterHistory.count > 80{
                    self.meterHistory.removeFirst(self.meterHistory.count - 80)
                }
            }
    }
    
    private static func normalize(_ db: Float) -> Float{
        let floor: Float = -60
        if db <= floor{return 0}
        let clamped = max(min(db,0),floor)
        return (clamped - floor) / -floor
    }
    
    private func stopMetering(){
        meterTimer?.cancel()
        meterTimer = nil
        meterLevel = 0
        meterHistory.removeAll()
    }
    
    func stop(){
        stopMetering()
        recorder?.stop()
        isRecording = false
        recorder = nil
        
    }
    
}
