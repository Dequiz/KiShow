//
//  ChartViewModel.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftData
import _SwiftData_SwiftUI
internal import Foundation

struct ChartItemData: Identifiable {
    var id: String { gender }
    let gender: String
    let count: Int
}

class ChartViewModel {
    var appearsMore: Dictionary<String, Int> = [:]
    
    func contarTotalDeItens(context: ModelContext) -> [ChartItemData] {
        // 1. Criamos o descriptor para a sua Entidade (ex: Pessoa)
        var descriptor = FetchDescriptor<EventEntity>()
        var ordenadoPorMaior: [ChartItemData] = []
        // 2. Otimização: Avisamos o SwiftData para buscar APENAS a propriedade 'nome'
        descriptor.propertiesToFetch = [\.show?.genderShow]
        
        do {
            // 3. Buscamos os dados do banco
            let pessoas = try context.fetch(descriptor)
            
            // 4. Extraímos apenas os nomes em um Array de Strings
            let todosOsNomes = pessoas.compactMap { pessoa -> String? in
                guard let nome = pessoa.show?.genderShow
                    .trimmingCharacters(in: .whitespacesAndNewlines),
                      !nome.isEmpty else {
                    return nil
                }

                let nomeNormalizado = nome.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                let valoresInvalidos: Set<String> = [
                    "undefined", "null", "unknown", "desconhecido", "genero", "genre", "n/a"
                ]
                return valoresInvalidos.contains(nomeNormalizado) ? nil : nome
            }
            
            // 5. Usamos o Dictionary(grouping:by:) para agrupar e contar os iguais
            let contagemDeNomes = Dictionary(grouping: todosOsNomes, by: { $0 })
                .mapValues { $0.count }
            
            // 6. Exibindo o resultado
            appearsMore = contagemDeNomes
            ordenadoPorMaior = contagemDeNomes
                .map { ChartItemData(gender: $0.key, count: $0.value) }
                .sorted { left, right in
                    if left.count != right.count {
                        return left.count > right.count
                    }
                    return left.gender.localizedCaseInsensitiveCompare(right.gender) == .orderedAscending
                }
        } catch {
            print("Erro ao buscar dados: \(error)")
        }
        return ordenadoPorMaior
    }
}

