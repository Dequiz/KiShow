//
//  ShowEntityViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//

internal import Foundation
import SwiftUI
import SwiftData
import TipKit

enum EventSaveError: LocalizedError {
    case missingShowDate

    var errorDescription: String? {
        switch self {
        case .missingShowDate:
            return "A data do show não está disponível."
        }
    }
}

@Observable
class EventEntityViewModel {
    
    func saveCustomShow(
        nameShow: String,
        dataShow: Date,
        artistShow: String,
        genderShow: String,
        imageData: Data?,
        localShow: String,
        addressShow: String,
        urlShow: String,
        startTime: Date,
        city: String,
        latitude: Double?,
        longitude: Double?,
        context: ModelContext
    ) throws {
        
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: startTime)
        let startTimeString = String(
            format: "%02d:%02d:00",
            comps.hour ?? 0,
            comps.minute ?? 0
        )

        let newShow = ShowEntity(
            nameShow: nameShow.trimmingCharacters(in: .whitespaces),
            dataShow: dataShow,
            artistShow: artistShow.trimmingCharacters(in: .whitespaces),
            genderShow: genderShow.isEmpty ? "Desconhecido" : genderShow,
            imageShow: imageData,
            localShow: localShow.isEmpty ? "Desconhecido" : localShow,
            addressShow: addressShow.isEmpty ? "Desconhecido" : addressShow,
            urlShow: urlShow,
            startTimeShow: startTimeString,
            city: city.isEmpty ? "Desconhecido" : city,
            latitude: latitude,
            longitude: longitude
        )

        try persist(newShow, context: context)
    }

    
    func saveShow(showTicket: TicketmasterShow, context: ModelContext) async throws {
        guard let date = parseDate(showTicket.dates?.start?.localDate) else {
            throw EventSaveError.missingShowDate
        }
        let time = parseTime(showTicket.dates?.start?.localTime ?? "00:00:00")

        var imageData: Data? = nil
        if let urlString = showTicket.images?
            .max(by: { ($0.width ?? 0) < ($1.width ?? 0) })?
            .url,
           let url = URL(string: urlString) {
            imageData = try? await URLSession.shared.data(from: url).0
        }

        let newShow = ShowEntity(
            nameShow: showTicket.name,
            dataShow: date,
            artistShow: showTicket.attraction?.name ?? "Desconhecido",
            genderShow: showTicket.classifications.first?.genre?.name ?? "Desconhecido",
            imageShow: imageData,
            localShow: showTicket.venue?.name ?? "Desconhecido",
            addressShow: showTicket.venue?.address?.line1 ?? "Desconhecido",
            urlShow: showTicket.url,
            startTimeShow: time,
            city: showTicket.venue?.city?.name ?? "Desconhecido",
            latitude: showTicket.latitude,
            longitude: showTicket.longitude
        )

        try persist(newShow, context: context)
    }

    private func persist(_ show: ShowEntity, context: ModelContext) throws {
        let event = EventEntity(show: show)
        context.insert(event)
        do {
            try context.save()
            CustomizeTicketTip.firstShowAdded.sendDonation()
        } catch {
            context.rollback()
            throw error
        }
    }
}
