//
//  RootView.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 30/09/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    var body: some View {
        TabView {
            TestView()
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }
            
            SavedShowsView()
                .tabItem {
                    Label("Meus Shows", systemImage: "music.note.list")
                }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: ShowEntity.self, inMemory: true)
}
