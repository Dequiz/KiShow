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
            let todosOsNomes = pessoas.map { $0.show?.genderShow ?? "Gênero" }
            
            // 5. Usamos o Dictionary(grouping:by:) para agrupar e contar os iguais
            let contagemDeNomes = Dictionary(grouping: todosOsNomes, by: { $0 })
                .mapValues { $0.count }
            
            // 6. Exibindo o resultado
            appearsMore = contagemDeNomes
            ordenadoPorMaior = contagemDeNomes
                .map { ChartItemData(gender: $0.key, count: $0.value) }
                .sorted { $0.count > $1.count }
            for (nome, quantidade) in contagemDeNomes {
                       print("O nome '\(nome)' aparece \(quantidade) vezes.")
                   }
        } catch {
            print("Erro ao buscar dados: \(error)")
        }
        return ordenadoPorMaior
    }
}

