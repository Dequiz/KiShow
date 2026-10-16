//
//  TicketMasterShowViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//


import SwiftUI

@Observable
class TicketMasterShowViewModel{
    enum LoadState {
        case idle
        case loading
        case loaded
        case failed
    }

    var shows: [TicketmasterShow] = []
    var query: String = ""
    var loadState: LoadState = .idle
    
    @ObservationIgnored
    private let showsCache = NSCache<NSString, CacheEntry>()
    
    init() {
       showsCache.countLimit = 10
       showsCache.totalCostLimit = 5_000_000
    }
    
    private final class CacheEntry {
        let shows: [TicketmasterShow]
        init(_ shows: [TicketmasterShow]) { self.shows = shows }
    }
    
    let genres = [
        "Pop",
        "World",
        "Rock",
        "Metal",
        "Latin",
        "R&B",
        "Blues",
        "Hip-Hop/Rap",
        "Ballads/Romantic",
        "Children's Music",
        "Classical",
        "Country",
        "Folk",
        "Dance/Electronic",
        "Holiday",
        "Jazz",
        "Medieval/Renaissance",
        "New Age",
        "Reggae",
        "Religious",
        "Chanson Francaise",
        "Alternative"
    ]
    
    let genresTranslations = [
        "Pop" : "Pop",
        "World" : "Estilos Regionais",
        "Rock" : "Rock",
        "Metal" : "Metal",
        "Latin" : "Musica Latina",
        "R&B" : "R&B",
        "Blues" : "Blues",
        "Hip-Hop/Rap" : "Rap/Trap/Funk",
        "Ballads/Romantic": "Balada Romantica",
        "Children's Music" : "Música Infantil",
        "Classical": "Clássica",
        "Country" : "Sertanejo",
        "Folk" : "Folk",
        "Dance/Electronic" : "Música Eletrônica/disco",
        "Holiday" : "Holiday",
        "Jazz" : "Jazz",
        "Alternative" : "Alternativa",
        "Reggae" : "Reggae",
        "Medieval/Renaissance" : "Música Medieval",
        "New Age" : "New Age" ,
        "Religious" : "Música Religiosa",
        "Chanson Francaise" : "Músíca francesa",
    ]
    
    
    var filteredShows: [TicketmasterShow] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return shows.sorted { ittem, ittem1 in
                (ittem.attraction?.name ?? "").localizedCaseInsensitiveCompare(ittem1.attraction?.name ?? "") == .orderedAscending
            }
        }
        let term = query.lowercased()
        return shows
            .filter { s in
                let artist = s.attraction?.name?.lowercased() ?? ""
                return artist.contains(term)
            }
            .sorted { s1, s2 in
                let name1 = s1.attraction?.name ?? ""
                let name2 = s2.attraction?.name ?? ""
                return name1.localizedCaseInsensitiveCompare(name2) == .orderedAscending
            }
    }
    
    var selectedGenres: [String] = []

    func addGenre(genre: String){
        if self.selectedGenres.contains(genre){
            selectedGenres.removeAll{ $0 == genre }
            return
        }
        
        if self.selectedGenres.count>=2 {
            self.selectedGenres.removeFirst()
            self.selectedGenres.append(genre)
            return
        }
        
        if !self.selectedGenres.contains(genre){
            selectedGenres.append(genre)
            return
        }
        
    }

    func fetchConcert(genre1: String, genre2: String = "") async {
        let key = cacheKey(genre1: genre1, genre2: genre2)
        
        if let cached = showsCache.object(forKey: key as NSString) {
            shows = cached.shows
            loadState = .loaded
            return
        }
        
        loadState = .loading
        do {
            let combined: [TicketmasterShow]
            if genre2.isEmpty {
                combined = try await WebService().downloadAllShows(genre: genre1)
            } else {
                async let request1 = WebService().downloadAllShows(genre: genre1)
                async let request2 = WebService().downloadAllShows(genre: genre2)
                combined = try await request1 + request2
            }
            
            var seen = Set<String>()
            let deduped = combined.filter { seen.insert($0.id).inserted }
            
            // Guarda no cache com um "custo" estimado
            let cost = MemoryLayout<TicketmasterShow>.stride * deduped.count
            showsCache.setObject(CacheEntry(deduped), forKey: key as NSString, cost: cost)
            
            shows = deduped
            loadState = .loaded
        } catch {
            shows = []
            loadState = .failed
        }
    }

    private func cacheKey(genre1: String, genre2: String) -> String {
        let parts = [genre1, genre2].filter { !$0.isEmpty }.sorted()
        return parts.joined(separator: "|")
    }
    
}
