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
    @State var isAddShow: Bool = false
    @State var actualShow: TicketmasterShow?
    var action: () -> Void
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible()),
            ],
        ) {
            ForEach(ticketMasterShow.filteredShows) { show in
                Button{
                    isAddShow.toggle()
                    actualShow = show
                    action()
                }label: {
                    Show(imageName: show.images?.max(by: { ($0.width ?? 0) < ($1.width ?? 0) })?.url ?? "Erro",
                         artistName: show.attraction?.name ?? "Desconhecido",
                         dateEvent: show.dates?.start?.localDate ?? "Sem data",
                         localEvent: show.venue?.name ?? "Local Desconhecido"
                    ).padding()
                }
            }
        }.padding(.leading)
            .padding(.trailing)
            .sheet(isPresented: $isAddShow){
                
                if let actualShow {
                    NavigationStack{
                        AddShow(ticketMasterShow: actualShow)
                            .toolbar{
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        isAddShow = false
                                    } label: {
                                        Image(systemName: "xmark")
                                    }
                                }
                            }
                    }
                    
                }
            }
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

