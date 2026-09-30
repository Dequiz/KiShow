//
//  Show.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI

struct Show: View {
    
    var imageName: String = "Teste" //Tirar essa imagem depois dos assets
    var artistName: String = "Nome Artista"
    var eventName: String = "Nome do Evento"
    var dateEvent: String = "Data"
    var localEvent: String = "Local"
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(width: 200, height: 250)
                .overlay (
                    ZStack (alignment: .bottomLeading){
                        LinearGradient(
                            colors: [.clear, .black.opacity(1)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        VStack (alignment: .leading, spacing: 4){
                            Spacer()
                            Text(artistName)
                                .foregroundColor(.white)
                                .font(.headline)
                            Text(eventName)
                                .foregroundColor(.white)
                                .font(.callout)
                            Text("\(dateEvent) | \(localEvent)")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                        .padding(15)
                    }
            

            )
        }
    }
}

#Preview {
    Show()
}
