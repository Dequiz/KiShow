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

struct ImageTicket: Decodable {
    let url: String
    let ratio: String?
    let width: Int?
    let height: Int?
}

struct EventEmbedded: Decodable {
    let venues: [Venue]?
    let attractions: [Attraction]?
}

struct TicketmasterShow: Decodable, Identifiable {
    let id: String
    let name: String
    let url: String
    let classifications: [Classification]
    let dates: EventDates?
    let embedded: EventEmbedded?
    
    let images: [ImageTicket]?


    enum CodingKeys: String, CodingKey {
        case id, name, url, classifications, dates, images
        case embedded = "_embedded"
    }

    var venue: Venue? {
        embedded?.venues?.first
    }
    
    var attraction: Attraction? {
        embedded?.attractions?.first
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id              = try container.decode(String.self, forKey: .id)
            self.name            = try container.decode(String.self, forKey: .name)
            self.url             = try container.decode(String.self, forKey: .url)
            self.classifications = try container.decodeIfPresent([Classification].self, forKey: .classifications) ?? []
            self.dates           = try container.decodeIfPresent(EventDates.self, forKey: .dates)
            self.embedded        = try container.decodeIfPresent(EventEmbedded.self, forKey: .embedded)
            self.images          = try container.decodeIfPresent([ImageTicket].self, forKey: .images)
        }
    
}


