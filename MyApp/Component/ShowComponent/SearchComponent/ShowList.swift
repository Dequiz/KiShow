//
//  ShowList.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 02/10/26.
//

import SwiftUI

struct ShowList: View {
    let ticketMasterShow: TicketMasterShowViewModel
    var genre: [String]
    var action: () -> Void

    
    @State private var selectedShow: TicketmasterShow?

    var body: some View {
        VStack {
            switch ticketMasterShow.loadState {
            case .loading:
                ProgressView("Buscando shows…")
                    .tint(.mainPink)
                    .padding()

            case .failed:
                ContentUnavailableView(
                    "Nenhum show encontrado",
                    systemImage: "music.note",
                    description: Text("Tente outra categoria ou pesquisa.")
                )
                .padding()

            case .idle, .loaded:
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible()),
                    ]
                ) {
                    ForEach(ticketMasterShow.filteredShows) { show in
                        Button {
                            selectedShow = show
                            action()
                        } label: {
                            Show(
                                imageName: show.images?.max(by: { ($0.width ?? 0) < ($1.width ?? 0) })?.url ?? "Teste",
                                artistName: show.attraction?.name ?? "Desconhecido",
                                dateEvent: show.dates?.start?.localDate ?? "Sem data",
                                city: show.venue?.city?.name ?? "Sem Cidade",
                                state: show.venue?.state?.stateCode ?? ""
                            )
                            .padding()
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .sheet(item: $selectedShow) { show in
            NavigationStack {
                AddShow(ticketMasterShow: show) {
                    selectedShow = nil
                }
            }
        }
        .task(id: genre) {
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
