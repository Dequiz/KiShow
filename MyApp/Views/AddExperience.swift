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

struct AddExperience: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var videoPicker = VideoPickerView()
    @State private var experiencia = ""
    @State private var isShowingVideoPicker = false
    @State private var itemSelecionado: PhotosPickerItem? = nil
        @State private var imagemCarregada: UIImage? = nil
    @State var viewModel = ExperienceViewModel()
   
    var body: some View {
        
        VStack{
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
            } else if viewModel.media == .video {
                VStack {
                    switch videoPicker.videoImportState {
                    case .success(let video):
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
                }
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
                        viewModel.saveExperience(description: experiencia, content: (imagemCarregada?.jpegData(compressionQuality: 0.5)) ?? Data(), mediaType: media, context: modelContext)
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
        TextField("Texto",text: $experiencia)
            MidiaPicker(viewModel: viewModel, alignment: .bottomTrailing)
    }
        
    
}
#Preview {
    AddExperience()
}
