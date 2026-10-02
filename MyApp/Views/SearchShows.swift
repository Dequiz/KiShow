//
//  SearchShows.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//

import SwiftUI


struct SearchShows: View {
    @State private var ticketMasterShow = TicketMasterShowViewModel()
    
    @State var query: String = ""
    
    @State var genresSelected: [String] = []
    
    @State var TaskId: UUID = UUID()
    
    var body: some View {
        NavigationStack{
            
            
            ScrollView {
                VStack{
                    Text("Categorias")
                        .font(.title2 .bold())
                        .multilineTextAlignment(.leading)
                    ScrollView(.horizontal){
                        HStack(spacing: 10){
                            ForEach(ticketMasterShow.genres, id:\.self){ genre in
                                FilterCategorie(optionGenre: genre){
                                        ticketMasterShow.addGenre(genre: genre)
                                        TaskId = UUID()
                                    }.background(ticketMasterShow.selectedGenres.contains(genre) ? .selectedCategorie : .categorieButton)
                                    .cornerRadius(23)
                                }
                            }
                            
                        }.padding()
                    }
                Text("Categorias Selecionadas: \(ticketMasterShow.selectedGenres.count)/2")
                
                Text(ticketMasterShow.selectedGenres.first ?? "ALL")
                     ShowList(Taskid: TaskId, genre: ticketMasterShow.selectedGenres.first ?? "ALL")
                }
            .navigationTitle("Buscar Shows")
            .toolbarTitleDisplayMode(.inlineLarge)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always) ,prompt: "Pesquise pelo show" )
            .searchDictationBehavior(.inline(activation: .onSelect))
                
            }
  
        }
    }
        

#Preview {
    SearchShows()

}
