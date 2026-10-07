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
    @Query var experiencies: [ExperienceEntity]
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
        .task(id: events.count) {
            dm.processAction(.showRegistered(totalShows: events.count), context: context)
        }
        .task(id: experiencies.count) {
            var countPhotos = 0
            for i in 0..<experiencies.count {
                if let temporary = experiencies[i].imageContent?.count {
                    countPhotos += temporary
                }
            }
            dm.processAction(.photosAdded(totalPhotos: countPhotos), context: context)
        }
        .task(id: experiencies.count) {
            var countText = 0
            for i in 0..<experiencies.count {
                if let temporary = experiencies[i].textContent?.count {
                    countText += temporary
                }
            }
            dm.processAction(.textAdded(totalText: countText), context: context)
        }
        .task(id: experiencies.count) {
            var totalChars = 0
            for experience in experiencies {
                if let texts = experience.textContent {
                    for text in texts {
                        totalChars += text.count
                    }
                }
            }
            dm.processAction(.textAdded(totalText: totalChars), context: context)
        }
    }
}
