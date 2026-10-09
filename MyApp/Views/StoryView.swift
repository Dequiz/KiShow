//
//  StoryView.swift
//  MyApp
//
//  Created by Andre on 07/10/26.
//

import SwiftUI

struct StoryView: View {
    let images: [Data]
    private let duracao = 3.0
    private let passo = 0.03
    @State var index = 0
    @State var progress = 0.0
    
    var body: some View {
        ZStack {
            if let photo = UIImage(data: images[index]) {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Text("Nenhuma foto disponível")
                    .foregroundStyle(.secondary)
            }
            HStack{
                Button{
                    storyAnterior()
                    
                }label: {
                    Rectangle()
                        .frame(width: 200,height: .infinity)
                        .foregroundStyle(Color.clear)
                }
                Button{
                    storySuperior()
                }label: {
                    Rectangle()
                        .frame(width: 200,height: .infinity)
                        .foregroundStyle(Color.clear)
                }
                
            }
        }
        .task(id: index) {
            await rodarStory()
        }
        .toolbar(.hidden,for:.tabBar)
        .toolbar {
            ForEach(images.indices, id: \.self) { i in
                ProgressView(value: valorBarra(para: i))
                    .tint(.white)
            }
        }
    }
    func storyAnterior() {
        if index == 0{
            return
        }else{
            progress -= 0.2
            index -= 1
        }
    }
    //    func executarStoryporTempo(){
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
    //
    //        }
    
    func storySuperior(){
        if index >= images.count - 1{
            return
        }else{
            progress += 0.2
            index += 1
        }
    }
    
    func valorBarra(para i: Int) -> Double {
        if i < index { return 1 }
        if i == index { return progress }
        return 0
    }
    
    func rodarStory() async {
        progress = 0
        let incremento = passo / duracao
        
        while progress < 1 {
            do {
                try await Task.sleep(for: .seconds(passo))
            } catch {
                return
            }
            progress += incremento
        }
        
        storySuperior()
    }
}

