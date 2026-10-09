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
    var experienceToEdit: ExperienceEntity? = nil
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
    @State private var didLoadExperienceForEditing = false
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.appBackground
                .ignoresSafeArea()
            ScrollView {
                mediaEditor
                    .frame(maxWidth: 560)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 112)
            }
            MidiaPicker(viewModel: viewModel, alignment: .bottomTrailing)
        }

        .task{
            prepareExperienceForEditing()
            rec.requestPermission{ _ in
            recordings = recordingList()
            }
        }

        .onChange(of: rec.isRecording) { _, isRecording in
            if isRecording {
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
                        saveExperience()
                    }
                }
            }
            .navigationTitle(experienceToEdit == nil ? "Nova experiência" : "Editar experiência")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: itemSelecionado) { _, novoItem in
                Task {
                    if let data = try? await novoItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        imagemCarregada = uiImage
                    }
                }
            }
    }

    private func prepareExperienceForEditing() {
        guard !didLoadExperienceForEditing else { return }
        didLoadExperienceForEditing = true
        guard let experienceToEdit else { return }

        experiencia = experienceToEdit.textContent?.first ?? ""
        switch experienceToEdit.type {
        case .image:
            viewModel.media = .photo
            if let imageData = experienceToEdit.imageContent?.first {
                imagemCarregada = UIImage(data: imageData)
            }
        case .video:
            viewModel.media = .video
            if let fileName = experienceToEdit.videoContent?.first {
                let url = URL.documentsDirectory.appending(path: fileName)
                if FileManager.default.fileExists(atPath: url.path) {
                    videoPicker.videoImportState = .success(AVPlayer(url: url), url)
                }
            }
        case .audio:
            viewModel.media = .audio
        case .text:
            viewModel.media = .text
        }
    }

    private func saveExperience() {
        let isNewExperience = experienceToEdit.map { _ in false } ?? true
        let target = experienceToEdit ?? ExperienceEntity(type: .text, event: eventoSelecionado)
        let oldVideoFile = target.type == .video ? target.videoContent?.first : nil

        target.textContent = [experiencia]
        target.imageContent = nil
        target.videoContent = nil
        target.audioContent = nil

        var newVideoFile: String?
        switch viewModel.media {
        case .text:
            target.type = .text
        case .photo:
            guard let image = imagemCarregada?.jpegData(compressionQuality: 0.7), !image.isEmpty else { return }
            target.type = .image
            target.imageContent = [image]
        case .video:
            guard case .success(_, let videoURL) = videoPicker.videoImportState else { return }
            let fileName = videoURL.lastPathComponent
            target.type = .video
            target.videoContent = [fileName]
            newVideoFile = fileName
        case .audio:
            if rec.isRecording { rec.stop() }
            let audioData: Data?
            if let recordingURL = rec.fileURL {
                audioData = try? Data(contentsOf: recordingURL)
            } else {
                audioData = experienceToEdit?.audioContent?.first
            }
            guard let audioData, !audioData.isEmpty else { return }
            target.type = .audio
            target.audioContent = [audioData]
        }

        if isNewExperience {
            modelContext.insert(target)
        }
        do {
            try modelContext.save()
        } catch {
            if isNewExperience { modelContext.delete(target) }
            print("Experience save failed: \(error)")
            return
        }

        if let oldVideoFile, oldVideoFile != newVideoFile {
            let oldVideoURL = URL.documentsDirectory.appending(path: oldVideoFile)
            try? FileManager.default.removeItem(at: oldVideoURL)
        }
        dismiss()
    }

    @ViewBuilder
    private var mediaEditor: some View {
        VStack(spacing: 20) {
            switch viewModel.media {
            case .text:
                descriptionField
            case .photo:
                PhotosPicker(selection: $itemSelecionado, matching: .images) {
                    Group {
                        if let imagemCarregada {
                            Image(uiImage: imagemCarregada)
                                .resizable()
                                .scaledToFill()
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.secondary)
                                .overlay {
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 38))
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                    .aspectRatio(4 / 3, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                descriptionField
            case .video:
                videoEditor
                descriptionField
            case .audio:
                audioEditor
                descriptionField
            }
        }
    }

    private var descriptionField: some View {
        TextField("Adicione uma descrição", text: $experiencia, axis: .vertical)
            .lineLimit(2...5)
            .padding(14)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
            .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var videoEditor: some View {
        switch videoPicker.videoImportState {
        case .success(let video, _):
            VideoPlayer(player: video)
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 315)
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
                .frame(maxWidth: .infinity)
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(maxHeight: 315)
        case .empty:
            videoPickerButton(isFailure: false)
        case .failure:
            videoPickerButton(isFailure: true)
        }
    }

    private func videoPickerButton(isFailure: Bool) -> some View {
        PhotosPicker(selection: $videoPicker.videoSelection, matching: .videos) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.secondary)
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .overlay {
                    Image(systemName: isFailure ? "exclamationmark.triangle.fill" : "video.badge.plus")
                        .font(.system(size: 38))
                        .foregroundStyle(isFailure ? Color.red : Color.white)
                }
        }
        .buttonStyle(.plain)
    }

    private var audioEditor: some View {
        HStack(spacing: 12) {
            Button {
                if let recordingURL = rec.fileURL {
                    player.play(recordingURL)
                } else if let experienceToEdit,
                          let audioData = experienceToEdit.audioContent?.first {
                    player.play(data: audioData, id: experienceToEdit.idExperience)
                }
            } label: {
                Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title3)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .disabled(rec.isRecording || (rec.fileURL == nil && experienceToEdit?.audioContent?.first == nil))
            .accessibilityLabel("Reproduzir áudio")

            BarVisualizer(values: rec.meterHistory, barCount: 32)
                .frame(maxWidth: .infinity)
                .frame(height: 64)

            Button {
                if rec.isRecording {
                    rec.stop()
                } else {
                    player.stop()
                    rec.start()
                }
            } label: {
                Image(systemName: rec.isRecording ? "stop.fill" : "mic.fill")
                    .font(.title3)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel(rec.isRecording ? "Parar gravação" : "Iniciar gravação")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.blueText.opacity(0.9), in: RoundedRectangle(cornerRadius: 20))
        .frame(maxWidth: .infinity)
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
