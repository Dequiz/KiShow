//
//  ShowEntityViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//

import Foundation
import SwiftUI
import SwiftData


@Observable
class EventEntityViewModel{
    func saveShow(showTicket: TicketmasterShow, context: ModelContext){
        
        
        
        guard let date = parseDate(showTicket.dates?.start?.localDate) else {
            return
        }
        let time = parseTime(showTicket.dates?.start?.localTime ?? "00:00:00")
        
        
        let newShow: ShowEntity = ShowEntity(nameShow: showTicket.name,
                                 dataShow: date,
                                 artistShow: showTicket.attraction?.name ?? "Desconhecido",
                                 genderShow: showTicket.classifications.first?.genre?.name ?? "Desconhecido",
                                 imageShow: showTicket.images?.max(by: { ($0.width ?? 0) < ($1.width ?? 0) })?.url ?? "Teste",
                                localShow: showTicket.venue?.name ?? "Desconhecido",
                                addressShow: showTicket.venue?.address?.line1 ?? "Desconhecido",
                                urlShow: showTicket.url,
                                startTimeShow: time,
                                city: showTicket.venue?.city?.name ?? "Desconhecido"
                                )
        
        let eventoSelecionado = EventEntity(show: newShow)
        context.insert(eventoSelecionado)
        
        do {
            try context.save()
        } catch {
            print("Erro ao salvar utilizador: \(error.localizedDescription)")
        }
    }
    
    func contains(showTicket: TicketmasterShow, shows: [EventEntity]) -> Bool{
        
        for show in shows {
            if showTicket.name == show.show?.nameShow && parseDate(showTicket.dates?.start?.localDate) == show.show?.dataShow{
                return true
            }
        }
        return false
    }
}
