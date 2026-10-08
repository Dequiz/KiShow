//
//  StoryView.swift
//  MyApp
//
//  Created by Andre on 07/10/26.
//

import SwiftUI

struct StoryView: View{
    var eventoSelecionado: EventEntity
    var images: [String]
    var body: some View{
    }
    func selectImages(){
        let img = eventoSelecionado.experiences?.randomElement()?.imageContent?.randomElement()
    }
}
