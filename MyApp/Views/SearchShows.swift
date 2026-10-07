//
//  SearchShows.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//

import SwiftUI


struct SearchShows: View {
    @State private var ticketMasterShow = TicketMasterShowViewModel()
    @State var TaskId: UUID = UUID()
    var body: some View {
        NavigationStack{
            
            ZStack{
                Color("SheetBackground")
                    .ignoresSafeArea()
                ScrollView {
                    VStack{
                        VStack(spacing: 1){
                            Text("Categorias")
                                .padding(.top)
                                .padding(.leading)
                                .font(.title2 .bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal){
                                HStack(spacing: 5){
                                    ForEach(ticketMasterShow.genres, id:\.self){ genre in
                                        FilterCategorie(optionGenre: ticketMasterShow.genresTranslations[genre] ?? "Gênero Inexistente"){
                                            ticketMasterShow.addGenre(genre: genre)
                                            TaskId = UUID()
                                        }.background(ticketMasterShow.selectedGenres.contains(genre) ? .selectedCategorie : .categorieButton)
                                            .cornerRadius(23)
                                            .padding(.leading, 5)
                                    }
                                }
                                
                            }.padding(.top)
                        }
                        Text("Categorias Selecionadas: \(ticketMasterShow.selectedGenres.count)/2")
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ShowList(ticketMasterShow: ticketMasterShow, Taskid: TaskId, genre: ticketMasterShow.selectedGenres){
                            TaskId = UUID()
                        }
                    }
                    
                    
                }.navigationTitle("Buscar Shows")
                    .toolbarTitleDisplayMode(.inlineLarge)
            }
            
        }.searchable(
            text: Binding(
                get: { ticketMasterShow.query },
                set: { ticketMasterShow.query = $0 }
            ),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Pesquise pelo show"
        )
        .searchDictationBehavior(.inline(activation: .onSelect))

    }
    }
        

#Preview {
    SearchShows()

}
