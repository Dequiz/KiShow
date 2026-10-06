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
                                   
                                    Ticket(
                                        ticketType: "BlueTicket",
                                        artistName: event.show?.artistShow ?? "Artista",
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
