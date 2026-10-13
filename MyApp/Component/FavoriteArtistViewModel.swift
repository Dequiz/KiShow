//
//  FavoriteArtistViewModel.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftData
internal import Foundation

struct ChartItemDataArtist: Identifiable {
    var id: String { artist }
    let artist: String
    let count: Int
}

class FavoriteArtistViewModel{
    var appearsMore: Dictionary<String, Int> = [:]
    func contarTotalDeItens(context: ModelContext) -> [ChartItemDataArtist] {
        // 1. Criamos o descriptor para a sua Entidade (ex: Pessoa)
        var descriptor = FetchDescriptor<EventEntity>()
        var ordenadoPorMaior: [ChartItemDataArtist] = []
        // 2. Otimização: Avisamos o SwiftData para buscar APENAS a propriedade 'nome'
        descriptor.propertiesToFetch = [\.show?.artistShow]
        
        do {
            // 3. Buscamos os dados do banco
            let pessoas = try context.fetch(descriptor)
            
            // 4. Extraímos apenas os nomes em um Array de Strings
            let todosOsNomes = pessoas.map { $0.show?.artistShow ?? "Gênero" }
            
            // 5. Usamos o Dictionary(grouping:by:) para agrupar e contar os iguais
            let contagemDeNomes = Dictionary(grouping: todosOsNomes, by: { $0 })
                .mapValues { $0.count }
            
            // 6. Exibindo o resultado
            appearsMore = contagemDeNomes
            ordenadoPorMaior = contagemDeNomes
                .map { ChartItemDataArtist(artist: $0.key, count: $0.value) }
                .sorted { left, right in
                    if left.count != right.count {
                        return left.count > right.count
                    }
                    return left.artist.localizedCaseInsensitiveCompare(right.artist) == .orderedAscending
                }
            for (nome, quantidade) in contagemDeNomes {
                       print("O Artista '\(nome)' aparece \(quantidade) vezes.")
                   }
        } catch {
            print("Erro ao buscar dados: \(error)")
        }
        return ordenadoPorMaior
    }
}
