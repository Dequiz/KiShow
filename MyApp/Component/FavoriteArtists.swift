//
//  FavoriteArtists.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftUI
import SwiftData


struct FavoriteArtists: View {
    @Query private var shows: [ShowEntity]

    private var artists: [ChartItemDataArtist] {
        Array(FavoriteArtistViewModel.contarTotalDeItens(shows: shows).prefix(4))
    }

    var body: some View {
        VStack(alignment:.leading){
            ForEach(Array(artists.enumerated()),id: \.element.id){ index, artist in
                Text(verbatim: "\(index + 1)˚ \(artist.artist)")
            }
        }
    }
}
