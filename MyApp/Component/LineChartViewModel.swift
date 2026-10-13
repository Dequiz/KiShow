//
//  LineChartViewModel.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

internal import Foundation
import SwiftData

class LineChartViewModel{
    
   
    func buscarShowsMes(mes: Int,context: ModelContext) -> Int{
        var descriptor = FetchDescriptor<EventEntity>()
        descriptor.propertiesToFetch = [\.show?.dataShow]
        let calendario = Calendar.current
        do {
            let pessoas = try context.fetch(descriptor)
            let quantidade = pessoas.filter { show in
                let mesDoShow = calendario.component(.month, from: show.show?.dataShow ?? Date())
                return mesDoShow == mes
            }.count
            
            return quantidade
            
        }catch {
            print("Erro ao buscar dados: \(error)")
            return 0
        }
    }
    
    
}
