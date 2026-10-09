//
//  CalendarManager.swift
//  MyApp
//
//  Created by Andre on 09/10/26.
//

import Foundation
import EventKit

class CalendarManager {
    let eventStore = EKEventStore()
    
    /// Solicita permissão e cria um compromisso no calendário nativo
    func criarCompromisso(titulo: String, dataInicio: Date, dataFim: Date, notas: String? = nil) async {
        do {
            // 1. Solicitar permissão de escrita (Ideal para iOS 17+)
            let permissaoConcedida = try await eventStore.requestWriteOnlyAccessToEvents()
            
            guard permissaoConcedida else {
                print("Acesso ao calendário foi negado pelo usuário.")
                return
            }
            
            // 2. Criar o objeto de evento
            let novoEvento = EKEvent(eventStore: eventStore)
            novoEvento.title = titulo
            novoEvento.startDate = dataInicio
            novoEvento.endDate = dataFim
            novoEvento.notes = notas
            
            // Define o calendário padrão para novos eventos (iCloud, Google, etc.)
            novoEvento.calendar = eventStore.defaultCalendarForNewEvents
            
            // 3. Salvar o evento no calendário
            // span: .thisEvent significa que altera apenas este compromisso (e não uma série recorrente)
            try eventStore.save(novoEvento, span: .thisEvent)
            
            print("Compromisso '\(titulo)' criado com sucesso!")
            
        } catch {
            print("Erro ao interagir com o calendário: \(error.localizedDescription)")
        }
    }
}
