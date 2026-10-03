//
//  ShowList.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 02/10/26.
//


import SwiftUI


struct ShowList: View {
    let ticketMasterShow: TicketMasterShowViewModel
    let Taskid: UUID
    var genre: [String]
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
            .task(id: Taskid) {
                switch genre.count {
                case 0:
                    await ticketMasterShow.fetchConcert(genre1: "Music")
                case 1:
                    await ticketMasterShow.fetchConcert(genre1: genre[0])
                default:
                    await ticketMasterShow.fetchConcert(genre1: genre[0], genre2: genre[1])
                }
            }
        
        
    }
}

