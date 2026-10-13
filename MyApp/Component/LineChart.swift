//
//  LineChart.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftUI
import SwiftData
import Charts

struct showsMonth: Identifiable{
    var month: String
    var count: Int
    var id = UUID()
}

struct LineChart: View{
    @Environment(\.modelContext) var context
    @State var viewModel = LineChartViewModel()
    @State private var data: [showsMonth] = []

    private let monthNames = [
        "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ]

    var body: some View{
        VStack {
            Chart(data) { item in
                LineMark(x: .value("Mês",item.month), y: .value("Quantidade", item.count))
                }
                .padding()

        }
        .task {
            data = monthNames.enumerated().map { index, month in
                showsMonth(month: month,
                           count: viewModel.buscarShowsMes(mes: index + 1, context: context))
            }
        }
    }
}
