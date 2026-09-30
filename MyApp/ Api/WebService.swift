//
//  WebService.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 28/09/26.
//

import Foundation


class WebService {
    
    let genreId: [String: String] = [
            "ALL": "KZFzniwnSyZfZ7v7nJ",
            "Pop": "KnvZfZ7vAev",
            "Rock": "KnvZfZ7vAeA",
            "Metal": "KnvZfZ7vAvt",
            "R&B": "KnvZfZ7vAee",
            "Jazz": "KnvZfZ7vAvE",
            "Classical": "KnvZfZ7vAeJ",
            "Latin": "KnvZfZ7vAJ6",
            "Hip-Hop": "KnvZfZ7vAv1",
            "Contry": "KnvZfZ7vAv6",
            "Folk": "KnvZfZ7vAva",
            "Children's Music": "KnvZfZ7vAvk",
            "Ballads/Romantic": "KnvZfZ7vAve",
            "Dance/Eletronic": "KnvZfZ7vAvF",
            "Blues": "KnvZfZ7vAvd",
            "Alternative": "KnvZfZ7vAvv",
            "Holiday": "KnvZfZ7vAvJ",
            "Medieval":"KnvZfZ7vAvI",
            "New Age": "KnvZfZ7vAvn",
            "Other": "KnvZfZ7vAvl",
            "Reggae": "KnvZfZ7vAed",
            "Religious": "KnvZfZ7vAe7",
            "Undefined": "KnvZfZ7vAe6",
            "World": "KnvZfZ7vAeF",
    ] ///Não sei se aqui é o melhor lugar para deixar isso
    
    
    func downloadAllShows(genre: String = "ALL") async -> [TicketmasterShow] {
        
        let urlString = "https://app.ticketmaster.com/discovery/v2/events?apikey=\(TicketMasterKey)&locale=*&countryCode=BR&classificationId=KZFzniwnSyZfZ7v7nJ"
        guard let url = URL(string: urlString) else {
            return []
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let responseObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let embedded = responseObject["_embedded"] as? [String: Any],
                  let events = embedded["events"],
                  JSONSerialization.isValidJSONObject(events) else {
                return []
            }

            let eventsData = try JSONSerialization.data(withJSONObject: events)
            return try JSONDecoder().decode([TicketmasterShow].self, from: eventsData)
        } catch {
            return []
        }
    }
    
}
