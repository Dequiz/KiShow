//
//  TicketMasterShowViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//


import SwiftUI

@Observable
class TicketMasterShowViewModel{
    var shows: [TicketmasterShow] = []
    var query: String = ""
    
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
        "Children's Music" : "Musica Infantil",
        "Classical": "Classica",
        "Country" : "Sertanejo",
        "Folk" : "Folk",
        "Dance/Electronic" : "Musica Eletronica/disco",
        "Holiday" : "Holiday",
        "Jazz" : "Jazz",
        "Alternative" : "Alternativa",
        "Reggae" : "Reggae",
        "Medieval/Renaissance" : "Musica Medieval",
        "New Age" : "New Age" ,
        "Religious" : "Musica Religiosa",
        "Chanson Francaise" : "Musíca francesa",
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
        
        if genre2.isEmpty {
            shows = await WebService().downloadAllShows(genre: genre1)
            return
        }
        async let requsition1 = WebService().downloadAllShows(genre: genre1)
        async let requsition2 = WebService().downloadAllShows(genre: genre2)
        let combined = await requsition1 + requsition2
        
        
        
        var seen = Set<String>()
        shows = combined.filter { seen.insert($0.id).inserted}
    }
    
}
