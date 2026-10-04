//
//  VideoPickerVIew.swift
//  MyApp
//
//  Created by Andre on 02/10/26.
//
import SwiftUI
import AVKit
import PhotosUI

@Observable
class VideoPickerView{
    enum VideoImportState {
        case empty
        case loading(Progress)
        case success(AVPlayer)
        case failure(Error)
    }
    var videoImportState : VideoImportState = .empty
    
    
    struct VideoType : Transferable{
        let url : URL
        
        static private func documentDirectory() -> String{
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)
            return documentDirectory[0]
        }
        
        static var transferRepresentation: some TransferRepresentation{
            FileRepresentation(contentType: .movie){ movie in
                SentTransferredFile(movie.url)
            }
            
            importing: { received in
                
                let fileName = received.file.lastPathComponent
                
                let copy: URL = URL(fileURLWithPath: "\(documentDirectory())/\(fileName)")
                try FileManager.default.copyItem(at: received.file, to: copy)
                
                return self.init(url: copy)
                
            }
        }
    }
    
    var videoSelection : PhotosPickerItem? = nil{
        didSet{
            if let videoSelection{
                let progress = loadTransferableVideo(from: videoSelection)
                videoImportState = .loading(progress)
            }else{
                videoImportState = .empty
            }
        }
    }
     
    private func loadTransferableVideo(from videoSelection: PhotosPickerItem) -> Progress {
            return videoSelection.loadTransferable(type: VideoType.self) { result in
                DispatchQueue.main.async {
                    guard videoSelection == self.videoSelection else {
                        print("Falhou em selecionar o item")
                        return
                    }
                    
                    switch result {
                    case .success(let profileVideo?):
                        let player = AVPlayer(url: profileVideo.url)
                        self.videoImportState = .success(player)
                    case .success(nil):
                        self.videoImportState = .empty
                    case .failure(let error):
                        self.videoImportState = .failure(error)
                    }
                }
            }
        }
}
