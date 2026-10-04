//
//  EventView.swift
//  MyApp
//
//  Created by Andre on 02/10/26.
//

import SwiftUI
import _SwiftData_SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case fotos = "Fotos"
    case videos = "Vídeos"
    case audios = "Audios"
    
    var id: String { self.rawValue }
}
struct EventView:View {
    @Environment(\.modelContext) var context
    @Query(sort: \ExperienceEntity.idExperience) var experiences : [ExperienceEntity]
    @State var selected = AppTheme.todos
    var body: some View {
       
        ScrollView{
            VStack{
                VinylRecord(fullVynil: 150, urlMusic: URL(string: "https://http2.mlstatic.com/D_NQ_NP_2X_983699-MLA96154876825_102025-F.webp")!)
                Spacer()
                Picker("",selection: $selected){
                    ForEach(AppTheme.allCases) { tipos in
                        Text(tipos.rawValue).tag(tipos)
                    }
                }
                .padding()
                .pickerStyle(.tabs)
                Spacer()
                if selected == .fotos{
                    Spacer()
                    VStack(spacing: 50){
                        ForEach(experiences){ experiences in
                            if experiences.type == .image{
                                VStack{
                                    if let uiImage = UIImage(data: experiences.imageContent?[0] ?? Data()){
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: .infinity,height: 200)
                                            .scaledToFill()
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .padding()
                                    }
                                    Text(experiences.textContent ?? "Tem uma imagem aí")
                                }
                                .contextMenu {
                                    Button("Excluir",role: .destructive){
                                        context.delete(experiences.self)
                                    }
                                }
                            }
                        }
                    }
                    .clipped()
                }else if selected == .todos{
                    ForEach(experiences){ experiences in
                        if experiences.type == .text{
                            Text(experiences.textContent ?? "Text Content")
                        }else if experiences.type == . image{
                            VStack{
                                if let uiImage = UIImage(data: experiences.imageContent?[0] ?? Data()){
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: .infinity,height: 200)
                                        .scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .padding()
                                }
                                Text(experiences.textContent ?? "Tem uma imagem aí")
                            }
//                            .contextMenu {
//                                Button("Excluir",role: .destructive){
//                                    context.delete(experiences.self)
//                                }
//                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink(destination: AddExperience()){
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

