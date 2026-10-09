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
    
    @State var selectPeriod: String = "Todos"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    Image(.camada1)
                        .resizable()
                        .frame(maxWidth:500)
                        .frame(height: 250)
                        .opacity(0.3)

                }
                .ignoresSafeArea()
                    
                    
                if events.isEmpty{
                    VStack{
                        Image(.guria1)
                            .resizable()
                            .frame(maxWidth: 263)
                            .frame(height: 279)
                        Text("Você ainda não possui nenhum show")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }else{
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
                                    ).padding()
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                context.delete(event)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        
                                    }
                                    
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                
            }.navigationTitle("Meus Shows")
                .toolbarTitleDisplayMode(.inlineLarge)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu{
                            Button{
                                selectPeriod = "Todos"
                            }label: {
                                HStack{
                                    Text("Todos")
                                    if selectPeriod == "Todos"{
                                        Image(systemName: "checkmark.circle")
                                    }
                                    
                                }
                            }
                            Button{
                                selectPeriod = "Próximos"
                            }label: {
                                HStack{
                                    Text("Próximos")
                                    if selectPeriod == "Próximos"{
                                        Image(systemName: "checkmark.circle")
                                    }
                                }
                            }
                            Button{
                                selectPeriod = "Encerrados"
                            }label: {
                                HStack{
                                    Text("Encerrados")
                                    if selectPeriod == "Encerrados"{
                                        Image(systemName: "checkmark.circle")
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease")
                        }
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


