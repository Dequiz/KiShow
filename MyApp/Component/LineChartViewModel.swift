//
//  LineChartViewModel.swift
//  MyApp
//

internal import Foundation
import SwiftData

final class LineChartViewModel {
    func buscarDatasDosShows(context: ModelContext) -> [Date] {
        var descriptor = FetchDescriptor<EventEntity>()
        descriptor.propertiesToFetch = [\.show?.dataShow]

        do {
            return try context.fetch(descriptor).compactMap { $0.show?.dataShow }
        } catch {
            print("Erro ao buscar datas dos shows: \(error)")
            return []
        }
    }
}
