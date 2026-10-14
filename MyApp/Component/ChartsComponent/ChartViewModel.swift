//
//  ChartViewModel.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

internal import Foundation

struct ChartItemData: Identifiable {
    var id: String { gender }
    let gender: String
    let count: Int
}

enum ChartViewModel {
    static func contarTotalDeItens(shows: [ShowEntity]) -> [ChartItemData] {
        let invalidValues: Set<String> = [
            "undefined", "null", "unknown", "desconhecido", "genero", "genre", "n/a"
        ]

        let genres = shows.compactMap { show -> String? in
            let genre = show.genderShow.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !genre.isEmpty else { return nil }

            let normalizedGenre = genre.folding(
                options: [.diacriticInsensitive, .caseInsensitive],
                locale: .current
            )
            return invalidValues.contains(normalizedGenre) ? nil : genre
        }

        return Dictionary(grouping: genres, by: { $0 })
            .map { ChartItemData(gender: $0.key, count: $0.value.count) }
            .sorted { left, right in
                if left.count != right.count {
                    return left.count > right.count
                }
                return left.gender.localizedCaseInsensitiveCompare(right.gender) == .orderedAscending
            }
    }
}
