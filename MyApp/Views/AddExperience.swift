//
//  AddExperience.swift
//  MyApp
//
//  Created by Andre on 01/10/26.
//

import SwiftUI
import _PhotosUI_SwiftUI
import SwiftData
import AVKit
import Combine
import AVFoundation

struct AddExperience: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var eventoSelecionado: EventEntity
    var dm = TitleDefinitionMachine()
    @Query var experiencies : [ExperienceEntity]
    @State var videoPicker = VideoPickerView()
    @State private var experiencia = ""
    @State private var isShowingVideoPicker = false
    @State private var itemSelecionado: PhotosPickerItem? = nil
        @State private var imagemCarregada: UIImage? = nil
    @State var viewModel = ExperienceViewModel()
   @State private var rec = Recorder()
    @State private var player = MiniPlayer()
    @State private var recordings: [URL] = []
    var body: some View {
        ZStack{
            Color.appBackground
                .ignoresSafeArea()
            VStack{
                if viewModel.media == .text{
                    TextField("Texto",text: $experiencia)
                }
                if viewModel.media == .photo{
                    PhotosPicker(selection: $itemSelecionado, matching: .images) {
                        if let imagemCarregada {
                            Image(uiImage: imagemCarregada)
                                .resizable()
                                .scaledToFill()
                                .frame(width: .infinity,height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding()
                        }else{
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.secondary)
                                .frame(width: .infinity,height: 300)
                                .padding()
                                .overlay() {
                                    Image(systemName: "photo.fill")
                                        .foregroundColor(.white)
                                }
                        }
                    }
                    TextField("Texto",text: $experiencia)
                } else if viewModel.media == .video {
                    VStack {
                        switch videoPicker.videoImportState {
                        case .success(let video, _):
                            VideoPlayer(player: video)
                                .frame(maxWidth: .infinity, minHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding()
                                .contextMenu {
                                    Button {
                                        isShowingVideoPicker = true
                                    } label: {
                                        Label("Editar", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive) {
                                        videoPicker.videoSelection = nil
                                    } label: {
                                        Label("Remover", systemImage: "trash")
                                    }
                                }
                                .photosPicker(
                                    isPresented: $isShowingVideoPicker,
                                    selection: $videoPicker.videoSelection,
                                    matching: .videos
                                )
                            
                        case .loading:
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 300)
                            
                        case .empty:
                            PhotosPicker(selection: $videoPicker.videoSelection, matching: .videos) {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, minHeight: 300)
                                    .overlay {
                                        Image(systemName: "video.badge.plus")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                            }
                            
                        case .failure:
                            PhotosPicker(selection: $videoPicker.videoSelection, matching: .videos) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, minHeight: 300)
                            }
                        }
                        TextField("Texto",text: $experiencia)
                    }
                }else if viewModel.media == .audio{
                    Spacer()
                    HStack{
                        Button{
                            player.play(rec.fileURL)
                        } label:{
                            Image(systemName: "play.fill")
                        }
                        .disabled(rec.isRecording || rec.fileURL == nil)
                        BarVisualizer(values: rec.meterHistory,barCount: 24)
                            .frame(height: 60)
                            .padding(.horizontal)
                            .background(Color.blueText)
                            .clipShape(.capsule)
                        
                        Button{
                            if rec.isRecording{
                                rec.stop()
                            }else{
                                player.stop()
                                rec.start()
                            }
                        } label:{
                            Image(systemName: rec.isRecording ? "mic.slash.fill" : "mic.fill")
                        }
                        TextField("Texto",text: $experiencia)
                    }
                    .frame(width: 200)
                    .padding()
                  
                }
               
                    MidiaPicker(viewModel: viewModel, alignment: .bottomTrailing)
                Spacer()
            }
                    }

        .task{
            rec.requestPermission{ _ in
            recordings = recordingList()
            }
        }
      

        .onChange(of: rec.isRecording) { isRecording in
            if isRecording{
                player.stop()
            }else{
                recordings = recordingList()
            }
        
        }
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        var media = TypeMidias.text
                        if imagemCarregada != nil{
                            media = TypeMidias.image
                        }
                        switch viewModel.media{
                        case .photo:
                            viewModel.saveExperience(event: eventoSelecionado, description: [experiencia], content: (imagemCarregada?.jpegData(compressionQuality: 0.5)) ?? Data(), mediaType: media, context: modelContext)
                        case .video:
                            if case .success(_, let videoURL) = videoPicker.videoImportState {
                                let fileName = videoURL.lastPathComponent // Ex: "7C4B1-23F.mp4"
                                viewModel.saveExperience(event: eventoSelecionado, description: [experiencia], content: [fileName], mediaType: .video, context: modelContext)
                            }
                        case .text:
                            viewModel.saveExperience(event: eventoSelecionado, description: [experiencia], content: experiencia, mediaType: .text, context: modelContext)
                        case .audio:
                                if let url = rec.fileURL, let audioData = try? Data(contentsOf: url) {
                                    viewModel.saveExperience(event: eventoSelecionado, description: [experiencia],
                                                             content: [audioData],
                                                             mediaType: .audio,
                                                             context: modelContext)
                                }
                        case .music:
                            print("Oi")
                        }
                       
                        dismiss()
                    }
                }
            }
            .onChange(of: itemSelecionado) { _, novoItem in
                Task {
                    if let data = try? await novoItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        imagemCarregada = uiImage
                    }
                }
            }
       
    }
     
    func recordingList() -> [URL]{
        let dir = try? FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Recordings", isDirectory: true)
        
        guard let dir, let files = try?
                FileManager.default.contentsOfDirectory(at: dir,includingPropertiesForKeys:nil)else{return []}
        
        return files.filter{
            $0.pathExtension == "m4a"
        }.sorted{
            $0.lastPathComponent > $1.lastPathComponent
        }
    }
        
    
}
//#Preview {
//    AddExperience()
//}
