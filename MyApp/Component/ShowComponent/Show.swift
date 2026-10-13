//
//  Show.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI

struct Show: View {
    
    var imageName: String
    var artistName: String
    var dateEvent: String
    var city: String
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: imageName)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 170, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
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
                                        .multilineTextAlignment(.leading)
                                    
                                        .foregroundColor(.white)
                                        .font(.callout)
                                    Text("\(formattedDate(parseDate(dateEvent)))")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                    Text(city)
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                }
                                .minimumScaleFactor(0.8)
                                .lineLimit(2)
                                .padding(15)
                            }
                
                    )
                default:
                    Color.gray.opacity(0.2)
                        .frame(width: 150, height: 250)
                }
            }
                
        }
    }
}

#Preview {
    Show(imageName: "https://s1.ticketm.net/dam/a/f3b/4e5c700e-50bb-4b8c-9673-9e4f9f2bef3b_RETINA_LANDSCAPE_16_9.jpg", artistName: "Nome do Artista", dateEvent: "data", city: "Sem cidade")
}
