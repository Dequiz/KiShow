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
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible()),
                    ],
                ) {
                    ForEach(ticketMasterShow.show) { show in
                        Button{
                            
                        }label: {
                            Show(imageName: show.images?.first?.url ?? "Erro",
                                 artistName: show.attraction?.name ?? "Desconhecido",
                                 dateEvent: show.dates?.start?.localDate ?? "Sem data",
                                 localEvent: show.venue?.name ?? "Local Desconhecido").padding()
                        }
                        
                    }
                }
            }
            .padding(20)
            .navigationTitle("Buscar Shows")
            .toolbarTitleDisplayMode(.inlineLarge)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always) ,prompt: "Pesquise pelo show" )
            .searchDictationBehavior(.inline(activation: .onSelect))
            .task {
                await ticketMasterShow.fetchConcert()
            }
           
        }
        }
        
}

#Preview {
    SearchShows()
    
    
}
