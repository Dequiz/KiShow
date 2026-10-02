//
//  FilterCategorie.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 02/10/26.
//

import SwiftUI

struct FilterCategorie: View {
    let optionGenre: String
    var action: () -> Void
    var body: some View {
        VStack{
            Button{
                action()
            }label: {
                Text(optionGenre)
                    .padding()
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        }
    }
}
#Preview {
    FilterCategorie(optionGenre: "ALL"){
        
    }
}
