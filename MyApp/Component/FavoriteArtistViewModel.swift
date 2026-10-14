//
//  FavoriteArtistViewModel.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

internal import Foundation

struct ChartItemDataArtist: Identifiable {
    var id: String { artist }
    let artist: String
    let count: Int
}

enum FavoriteArtistViewModel {
    static func contarTotalDeItens(shows: [ShowEntity]) -> [ChartItemDataArtist] {
        let artists = shows.compactMap { show -> String? in
            let artist = show.artistShow.trimmingCharacters(in: .whitespacesAndNewlines)
            return artist.isEmpty ? nil : artist
        }

        return Dictionary(grouping: artists, by: { $0 })
            .map { ChartItemDataArtist(artist: $0.key, count: $0.value.count) }
            .sorted { left, right in
                if left.count != right.count {
                    return left.count > right.count
                }
                return left.artist.localizedCaseInsensitiveCompare(right.artist) == .orderedAscending
            }
    }
}
