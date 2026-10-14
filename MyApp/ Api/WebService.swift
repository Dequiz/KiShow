////
////  WebService.swift
////  MyApp
////
////  Created by Paulo Eduardo Barbosa da Silva on 28/09/26.


internal import Foundation

enum EventSearchError: Error {
    case apiKeyMissing
    case invalidResponse
    case serverRejectedRequest
}

class WebService {

    
    let ticketMasterShow =  TicketMasterShowViewModel()
    
    func downloadAllShows(genre: String) async throws -> [TicketmasterShow] {
        guard ticketMasterShow.genres.contains(genre) || genre == "Music" else {
            return []
        }
        
        let apiKey = TicketmasterConfiguration.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !apiKey.isEmpty else { throw EventSearchError.apiKeyMissing }
        guard var components = URLComponents(string: "https://app.ticketmaster.com/discovery/v2/events") else {
            throw EventSearchError.invalidResponse
        }
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "locale", value: "*"),
            URLQueryItem(name: "countryCode", value: "BR"),
            URLQueryItem(name: "classificationName", value: genre),
            URLQueryItem(name: "size", value: "100"),
            URLQueryItem(name: "page", value: "0")
        ]
        guard let url = components.url else { throw EventSearchError.invalidResponse }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw EventSearchError.invalidResponse
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw EventSearchError.serverRejectedRequest
            }
            guard let responseObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let embedded = responseObject["_embedded"] as? [String: Any],
                  let events = embedded["events"] else {
                return []
            }
            guard JSONSerialization.isValidJSONObject(events) else {
                throw EventSearchError.invalidResponse
            }

            let eventsData = try JSONSerialization.data(withJSONObject: events)
            let shows = try JSONDecoder().decode([TicketmasterShow].self, from: eventsData)
            
            if genre == "Music"{
                return shows
            }

            return shows.filter { show in
                // se não tem classificação, mantém (não corta)
                guard !show.classifications.isEmpty else { return true }
                return show.classifications.contains { c in
                    c.genre?.name == genre || c.subGenre?.name == genre
                }
            }
        }
    }

}
