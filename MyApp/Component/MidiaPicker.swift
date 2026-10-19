//
//  MidiaPicker.swift
//  MyApp
//
//  Created by Andre on 01/10/26.
//

import SwiftUI
import TipKit

struct MidiaPicker: View {
    var insertMidia = InsertMidiaTip()
    var viewModel: ExperienceViewModel
    var alignment : Alignment
    var body: some View {
        HStack(spacing:15){
            Button("", systemImage: "photo.fill.on.rectangle.fill"){
                viewModel.media = ExperienceViewModel.MediaTypes.photo
            }
            .accessibilityLabel("Adicionar foto")
            Button("", systemImage: "video.fill"){
                viewModel.media = ExperienceViewModel.MediaTypes.video
            }
            .accessibilityLabel("Adicionar vídeo")
            Button("", systemImage: "waveform"){
                viewModel.media = ExperienceViewModel.MediaTypes.audio
            }
            .accessibilityLabel("Adicionar áudio")
            Button("", systemImage: "text.alignleft"){
                viewModel.media = ExperienceViewModel.MediaTypes.text
            }
            .accessibilityLabel("Adicionar texto")
        }
        .popoverTip(insertMidia, arrowEdge: .bottom)
        .tipViewStyle(MidiasTipStyle())
        .padding()
        .glassEffect()
        .padding([.trailing,.bottom],15)
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}
        


//#Preview {
//    MidiaPicker(alignment: .bottomTrailing)
//}
