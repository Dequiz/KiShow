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
    @Query var experiences: [ExperienceEntity]
//    @Query var shows : [EventEntity]
    var dm = TitleDefinitionMachine()
    @Environment(\.modelContext) var context
    
    var body: some View {
        
            
            NavigationStack {
                ZStack {
                    Color("AppBackground")
                        .ignoresSafeArea()
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
        
        .task {
            if events.count == 1{
                dm.unlockTitle(texto: "Colecionador", context: context)
            }
            
        }

    }
}


