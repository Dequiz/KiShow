//
//  Categories.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 15/10/26.
//

import SwiftUI

struct Categories: View {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            ScrollView {
                VStack (alignment: .leading, spacing: 20){
                    Text("O Kishow possui ilustrações autorais para algumas das categorias presentes no aplicativo, as quais são as mesmas que você pode selecionar como foto de perfil.")
                        .font(.body)
                    Text("Confira-as em maiores detalhes a seguir!")
                        .font(.body)
                    
                    Text("Categorias ilustradas")
                        .font(.title)
                        .fontWeight(.bold)
          
                    LazyVGrid(columns: columns, spacing: 12) {
                        ShowCategories(categoryName: "Pop", categoryImage: .pop)
                        ShowCategories(categoryName: "Rock", categoryImage: .rock)
                        ShowCategories(categoryName: "Metal", categoryImage: .metal)
                        ShowCategories(categoryName: "Blues", categoryImage: .blues)
                        ShowCategories(categoryName: "Infantil", categoryImage: .juvenile)
                        ShowCategories(categoryName: "Sertanejo", categoryImage: .country)
                        ShowCategories(categoryName: "Eletrônica", categoryImage: .eletronic)
                        ShowCategories(categoryName: "Feriado", categoryImage: .holiday)
                        ShowCategories(categoryName: "Jazz", categoryImage: .jazz)
                        ShowCategories(categoryName: "Medieval", categoryImage: .medieval)
                        ShowCategories(categoryName: "Reggae", categoryImage: .reggae)
                        ShowCategories(categoryName: "Alternativa", categoryImage: .alternative)
                        ShowCategories(categoryName: "Clássica", categoryImage: .classic)
                    }
                    .padding(.vertical, 10)
                    
                    Spacer()
                    
                    Text("Última atualização: 15 de Outubro de 2026")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .navigationTitle("Categorias Musicais")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    Categories()
}
