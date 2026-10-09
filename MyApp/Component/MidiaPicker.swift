//
//  MidiaPicker.swift
//  MyApp
//
//  Created by Andre on 01/10/26.
//

import SwiftUI

struct MidiaPicker: View {
    var viewModel: ExperienceViewModel
    var alignment : Alignment
    var body: some View {
        HStack(spacing:15){
            Button("", systemImage: "photo.fill.on.rectangle.fill"){
                viewModel.media = ExperienceViewModel.MediaTypes.photo
                print(viewModel.media)
            }
            Button("", systemImage: "video.fill"){
                viewModel.media = ExperienceViewModel.MediaTypes.video
                print(viewModel.media)
            }
            Button("", systemImage: "waveform"){
                viewModel.media = ExperienceViewModel.MediaTypes.audio
                print(viewModel.media)
            }
            Button("", systemImage: "text.alignleft"){
                viewModel.media = ExperienceViewModel.MediaTypes.text
                print(viewModel.media)
            }
        }
        .padding()
        .glassEffect()
        .padding([.trailing,.bottom],15)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}
        


//#Preview {
//    MidiaPicker(alignment: .bottomTrailing)
//}
