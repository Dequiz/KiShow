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
import TipKit

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
    @State private var isShowingMicrophonePermissionAlert = false
    @State private var validationMessage: String?
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
            recordings = recordingList()
        }

        .onChange(of: rec.isRecording) { _, isRecording in
            validationMessage = nil
            if isRecording {
                player.stop()
            }else{
                recordings = recordingList()
            }
        
        }
        .onChange(of: viewModel.media) { _, _ in
            validationMessage = nil
        }
        .onChange(of: videoPicker.videoSelection) { _, _ in
            validationMessage = nil
        }
        .onChange(of: experiencia) { _, _ in
            validationMessage = nil
        }
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                    .tint(.primary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        saveExperience()
                    }
                }
            }
            .navigationTitle(experienceToEdit == nil ? "Nova experiência" : "Editar experiência")
            .navigationBarTitleDisplayMode(.inline)
            .background {
                Color.clear
                    .tint(.primary)
                    .alert("Acesso ao microfone", isPresented: $isShowingMicrophonePermissionAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Para gravar uma lembrança em áudio, permita o acesso ao microfone nos Ajustes do dispositivo.")
                    }
            }
            .onChange(of: itemSelecionado) { _, novoItem in
                validationMessage = nil
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
        let cleanedDescription = experiencia.trimmingCharacters(in: .whitespacesAndNewlines)
        let optionalDescription: [String]? = cleanedDescription.isEmpty ? nil : [cleanedDescription]

        var mediaType: TypeMidias
        var imageContent: [Data]? = nil
        var videoContent: [String]? = nil
        var audioContent: [Data]? = nil

        switch viewModel.media {
        case .text:
            guard !cleanedDescription.isEmpty else {
                validationMessage = "Escreva uma lembrança antes de salvar."
                return
            }
            mediaType = .text
        case .photo:
            guard let image = imagemCarregada?.jpegData(compressionQuality: 0.7), !image.isEmpty else {
                validationMessage = "Adicione uma foto antes de salvar."
                return
            }
            mediaType = .image
            imageContent = [image]
        case .video:
            guard case .success(_, let videoURL) = videoPicker.videoImportState,
                  hasNonEmptyFile(at: videoURL) else {
                validationMessage = "Selecione um vídeo e aguarde o carregamento antes de salvar."
                return
            }
            let fileName = videoURL.lastPathComponent
            mediaType = .video
            videoContent = [fileName]
        case .audio:
            if rec.isRecording { rec.stop() }
            let audioData: Data?
            if let recordingURL = rec.fileURL {
                audioData = try? Data(contentsOf: recordingURL)
            } else {
                audioData = experienceToEdit?.audioContent?.first
            }
            guard let audioData, !audioData.isEmpty else {
                validationMessage = "Grave um áudio antes de salvar."
                return
            }
            mediaType = .audio
            audioContent = [audioData]
        }

        let isNewExperience = experienceToEdit == nil
        let eventAlreadyHasExperiences = eventoSelecionado.experiences?.isEmpty == false
            || experiencies.contains { $0.event?.idEvent == eventoSelecionado.idEvent }
        let isFirstExperienceForEvent = isNewExperience && !eventAlreadyHasExperiences
        let target = experienceToEdit ?? ExperienceEntity(type: mediaType, event: eventoSelecionado)
        let oldType = target.type
        let oldTextContent = target.textContent
        let oldImageContent = target.imageContent
        let oldVideoContent = target.videoContent
        let oldAudioContent = target.audioContent
        let oldVideoFile = target.type == .video ? target.videoContent?.first : nil

        target.type = mediaType
        target.textContent = optionalDescription
        target.imageContent = imageContent
        target.videoContent = videoContent
        target.audioContent = audioContent

        if isNewExperience {
            modelContext.insert(target)
        }
        do {
            try modelContext.save()
        } catch {
            if isNewExperience {
                modelContext.delete(target)
            } else {
                target.type = oldType
                target.textContent = oldTextContent
                target.imageContent = oldImageContent
                target.videoContent = oldVideoContent
                target.audioContent = oldAudioContent
            }
            validationMessage = "Não foi possível salvar. Tente novamente."
            return
        }

        if isFirstExperienceForEvent {
            EventStoryTip.firstExperienceAdded.sendDonation()
        }

        let newVideoFile = videoContent?.first
        if let oldVideoFile, oldVideoFile != newVideoFile {
            let oldVideoURL = URL.documentsDirectory.appending(path: oldVideoFile)
            try? FileManager.default.removeItem(at: oldVideoURL)
        }
        validationMessage = nil
        dismiss()
    }

    private func hasNonEmptyFile(at url: URL) -> Bool {
        guard FileManager.default.fileExists(atPath: url.path),
              let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let size = attributes[.size] as? NSNumber else {
            return false
        }
        return size.intValue > 0
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

            if let validationMessage {
                Label(validationMessage, systemImage: "exclamationmark.circle.fill")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityAddTraits(.updatesFrequently)
            }
        }
    }

    private var descriptionField: some View {
        TextField("Adicione uma descrição", text: $experiencia, axis: .vertical)
            .lineLimit(2...5)
            .padding(14)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
            .foregroundStyle(Color.primary)
            .tint(.mainPink)
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
                    rec.requestPermission { granted in
                        guard granted else {
                            isShowingMicrophonePermissionAlert = true
                            return
                        }
                        rec.start()
                        recordings = recordingList()
                    }
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
