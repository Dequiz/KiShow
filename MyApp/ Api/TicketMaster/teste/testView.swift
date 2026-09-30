//
//  testView.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 30/09/26.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @Environment(\.modelContext) private var context
    @State private var showsTicket = TicketMasterShowViewModel()
    @State private var savedShowIDs: Set<String> = []   // opcional: feedback visual

    var body: some View {
        List(showsTicket.show) { show in
            HStack {
                Text(show.name)
                Spacer()
                Button {
                    addShowToSwiftData(show)
                } label: {
                    Image(systemName: savedShowIDs.contains(show.id)
                          ? "checkmark.circle.fill"
                          : "plus.circle")
                        .foregroundStyle(savedShowIDs.contains(show.id) ? .green : .blue)
                }
                .buttonStyle(.plain)
            }
        }
        .task {
            await showsTicket.fetchConcert()
        }
    }

    private func addShowToSwiftData(_ show: TicketmasterShow) {
        // Converte TicketmasterShow -> ShowEntity
        let entity = ShowEntityViewModel.makeEntity(from: show)

        // Insere no contexto do SwiftData
        context.insert(entity)

        // (opcional) salva imediatamente
        do {
            try context.save()
            savedShowIDs.insert(show.id)
        } catch {
            print("Erro ao salvar: \(error)")
        }
    }
}

#Preview{
    TestView()
        .modelContainer(for: ShowEntity.self)
}
