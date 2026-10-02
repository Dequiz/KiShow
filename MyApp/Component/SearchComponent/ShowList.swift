//
//  ShowList.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 02/10/26.
//


import SwiftUI


struct ShowList: View {
    @State private var ticketMasterShow = TicketMasterShowViewModel()
    let genre: String
    var body: some View {
        Text("Total ittens \(ticketMasterShow.show.count)")
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
                         localEvent: show.venue?.name ?? "Local Desconhecido"
                    ).padding()
                }
            }
        }.padding(.leading)
            .padding(.trailing)
            .task {
                await ticketMasterShow.fetchConcert(genre: genre ?? "ALL")
            }
        
        
    }
}
#Preview {
    ScrollView{
        ShowList(genre: "ALL")
    }
    
}
