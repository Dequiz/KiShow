//
//  SavedShoesView.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 30/09/26.
//

import SwiftUI
import SwiftData

struct SavedShowsView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Busca todos os ShowEntity, ordenados pela data
    @Query(sort: \ShowEntity.dataShow, order: .forward)
    private var savedShows: [ShowEntity]
    
    var body: some View {
        NavigationStack {
            Group {
                if savedShows.isEmpty {
                    ContentUnavailableView(
                        "Nenhum show salvo",
                        systemImage: "music.note.list",
                        description: Text("Adicione shows na tela inicial para vê-los aqui.")
                    )
                } else {
                    List {
                        ForEach(savedShows) { show in
                            NavigationLink {
                                ShowDetailView(show: show)
                            } label: {
                                SavedShowRow(show: show)
                            }
                        }
                        .onDelete(perform: deleteShows)
                    }
                }
            }
            .navigationTitle("Meus Shows")
            .toolbar {
                if !savedShows.isEmpty {
                    EditButton()
                }
            }
        }
    }
    
    private func deleteShows(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(savedShows[index])
        }
        try? modelContext.save()
    }
}
