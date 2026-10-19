//
//  FavoriteArtistViewModel.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

internal import Foundation

struct ChartItemDataArtist: Identifiable {
    var id: String { artist.localizedLowercase }
    let artist: String
    let count: Int
    let imageData: Data?
}

enum FavoriteArtistViewModel {
    static func contarTotalDeItens(shows: [ShowEntity]) -> [ChartItemDataArtist] {
        let showsByArtist = Dictionary(grouping: shows.compactMap { show -> (String, ShowEntity)? in
            let artist = show.artistShow.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !artist.isEmpty else { return nil }
            return (artist.localizedLowercase, show)
        }, by: { $0.0 })

        return showsByArtist
            .map { key, entries in
                let artistShows = entries.map { $0.1 }
                let artist = artistShows.first?.artistShow.trimmingCharacters(in: .whitespacesAndNewlines) ?? key
                let imageData = artistShows
                    .sorted { $0.dataShow > $1.dataShow }
                    .compactMap { $0.imageShow }
                    .first

                return ChartItemDataArtist(
                    artist: artist,
                    count: entries.count,
                    imageData: imageData
                )
            }
            .sorted { left, right in
                if left.count != right.count {
                    return left.count > right.count
                }
                return left.artist.localizedCaseInsensitiveCompare(right.artist) == .orderedAscending
            }
    }
}
