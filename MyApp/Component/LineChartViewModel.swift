//
//  LineChartViewModel.swift
//  MyApp
//

internal import Foundation
import SwiftData

final class LineChartViewModel {
    func buscarDatasDosShows(context: ModelContext) -> [Date]? {
        let descriptor = FetchDescriptor<EventEntity>()

        do {
            return try context.fetch(descriptor).compactMap { $0.show?.dataShow }
        } catch {
            return nil
        }
    }
}
