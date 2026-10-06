//
//  MyShows.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//

import SwiftUI
import SwiftData

struct MyShows: View {
    @Query var events: [EventEntity]
    
    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(events) { event in
                           
                                NavigationLink {
                                    EventView(eventoSelecionado: event)
                                } label: {
                                   
                                    TicketSelection(
                                        artistName: event.show?.artistShow ?? "Artista",
                                        eventName: event.show?.nameShow ?? "Evento",
                                        localName: event.show?.localShow ?? "Local",
                                        dateEvent: event.show?.dataShow ?? Date()
                                    )
                                    
                                }
                                .buttonStyle(.plain)
                            
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
