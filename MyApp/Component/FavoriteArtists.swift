//
//  FavoriteArtists.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftUI
import SwiftData


struct FavoriteArtists: View {
    @Environment(\.modelContext) var context
    @State var viewModel = FavoriteArtistViewModel()
    @State var artists = [ChartItemDataArtist]().prefix(4)
    var body: some View {
        VStack(alignment:.leading){
            ForEach(Array(artists.enumerated()),id: \.element.id){ index, artist in
                Text(verbatim: "\(index + 1)˚ \(artist.artist)")
            }
        }
        .task {
            artists = viewModel.contarTotalDeItens(context: context).prefix(4)
        }
    }
}
