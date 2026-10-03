//
//  TicketMasterShowViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//


import SwiftUI



@Observable




class TicketMasterShowViewModel{
    var show: [TicketmasterShow] = []
    
    let genres = [
        "Alternative",
        "Ballads/Romantic",
        "Blues",
        "Children's Music",
        "Chanson Francaise",
        "Classical",
        "Country",
        "Dance/Electronic",
        "Folk",
        "Hip-Hop/Rap",
        "Holiday",
        "Jazz",
        "Latin",
        "Medieval/Renaissance",
        "Metal",
        "New Age",
        "Pop",
        "R&B",
        "Reggae",
        "Religious",
        "Rock",
        "World"
    ]
    
    
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
            show = await WebService().downloadAllShows(genre: genre1)
            return
        }
        async let requsition1 = WebService().downloadAllShows(genre: genre1)
        async let requsition2 = WebService().downloadAllShows(genre: genre2)
        show = await requsition1 + requsition2
    }
    
}
