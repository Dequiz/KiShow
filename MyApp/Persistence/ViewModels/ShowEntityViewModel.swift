//
//  ShowEntityViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//

import Foundation
import SwiftUI


@Observable
class ShowEntityViewModel{
    var show: ShowEntity
    
    private var showTicketmaster: TicketmasterShow
    
    private static func parseDate(_ string: String?) -> Date {
        guard let string else { return Date() }
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f.date(from: string) ?? Date()
    }
    init(showTicketmaster: TicketmasterShow) {
        self.showTicketmaster = showTicketmaster
        self.show = ShowEntityViewModel.makeEntity(from: showTicketmaster)
    }
    
    static func makeEntity(from showTicketmaster: TicketmasterShow) -> ShowEntity {
        ShowEntity(
            nameShow: showTicketmaster.name,
            dataShow: parseDate(showTicketmaster.dates?.start?.localDate),
            artistShow: showTicketmaster.attraction?.name ?? "Artista desconhecido",
            genderShow: showTicketmaster.classifications.first(where: { $0.primary == true })?.genre?.name
            ?? showTicketmaster.classifications.first?.genre?.name
            ?? "Gênero desconhecido",
            imageShow: showTicketmaster.images?.max(by: { ($0.width ?? 0) < ($1.width ?? 0) })?.url ?? "Teste",
            localShow: showTicketmaster.venue?.name ?? "Local desconhecido",
            addressShow: showTicketmaster.venue?.address?.line1 ?? "Sem Nome",
            urlShow: showTicketmaster.url,
            startTimeShow: showTicketmaster.dates?.start?.localTime ?? "Horário não definido",
            city: showTicketmaster.venue?.city?.name ?? "Cidade desconhecida"
        )
    }
    
}
