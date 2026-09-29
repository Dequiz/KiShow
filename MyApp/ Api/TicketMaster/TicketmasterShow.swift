//
//  TicketmasterShow.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//

//This is a model for conection ticketmaster api with swiftdata

struct Genre: Decodable {
    let id: String
    let name: String
}

struct Classification: Decodable {
    let primary: Bool?
    let genre: Genre?
}

struct EventStart: Decodable {
    let localDate: String?
    let localTime: String?
}

struct EventDates: Decodable {
    let start: EventStart?
}


struct City: Decodable {
    let name: String?
}

struct Address: Decodable {
    let line1: String?
}


struct Venue: Decodable {
    let name: String?
    let city: City?
    let address: Address?
}

struct Attraction: Decodable{
    let name: String?
}


struct EventEmbedded: Decodable {
    let venues: [Venue]?
    let atractions: [Attraction]?
}

struct TicketmasterShow: Decodable, Identifiable {
    let id: String
    let name: String
    let url: String
    let classifications: [Classification]
    let dates: EventDates?
    let embedded: EventEmbedded?

    enum CodingKeys: String, CodingKey {
        case id, name, url, classifications, dates
        case embedded = "_embedded"
    }

    var venue: Venue? {
        embedded?.venues?.first
    }
}
