////
////  WebService.swift
////  MyApp
////
////  Created by Paulo Eduardo Barbosa da Silva on 28/09/26.
////
//
//import Foundation
//
//
//class WebService {
//    
//    
//    
//    func downloadData() async -> [TicketmasterShow] {
////        
////        let urlString = "https://app.ticketmaster.com/discovery/v2/events?apikey=\(TicketMasterKey)&locale=*&countryCode=BR&classificationId=KZFzniwnSyZfZ7v7nJ"
////        guard let url = URL(string: urlString) else {
////            return []
////        }
//
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode),
//                  let responseObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                  let embedded = responseObject["_embedded"] as? [String: Any],
//                  let events = embedded["events"],
//                  JSONSerialization.isValidJSONObject(events) else {
//                return []
//            }
//
//            let eventsData = try JSONSerialization.data(withJSONObject: events)
//            return try JSONDecoder().decode([TicketmasterShow].self, from: eventsData)
//        } catch {
//            return []
//        }
//    }
//}
