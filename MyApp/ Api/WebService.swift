////
////  WebService.swift
////  MyApp
////
////  Created by Paulo Eduardo Barbosa da Silva on 28/09/26.


import Foundation


class WebService {

    
    let ticketMasterShow =  TicketMasterShowViewModel()
    
    func downloadAllShows(genre: String) async -> [TicketmasterShow] {
        guard ticketMasterShow.genres.contains(genre) || genre == "Music" else {
            return []
        }
        
        let urlString = "https://app.ticketmaster.com/discovery/v2/events?apikey=\(TicketMasterKey)&locale=*&countryCode=BR&classificationName=\(genre)&size=100&page=0"
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
        } catch {
            return []
        }
    }

}
