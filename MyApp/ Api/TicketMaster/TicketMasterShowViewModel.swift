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
            "Alternative", "Ballads/Romantic", "Blues",
            "Children's", "Music", "Classical", "Country",
            "Dance/Electronic", "Folk", "Hip-Hop", "Holiday",
            "Jazz", "Latin", "Medieval", "Metal", "New Age",
            "Other", "Pop", "R&B", "Reggae", "Religious",
            "Rock", "Undefined", "World"
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

    func fetchConcert(genre: String = "ALL") async {
        show = await WebService().downloadAllShows(genre: genre)
    }
    
    
}
