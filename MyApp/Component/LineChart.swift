//
//  LineChart.swift
//  MyApp
//

import SwiftUI
import SwiftData
import Charts

private struct ShowsMonth: Identifiable {
    let month: Int
    let position: Double
    let count: Int
    var id: Int { month }
}

struct LineChart: View {
    private let monthSlotWidth: CGFloat = 60
    private let chartHeight: CGFloat = 190
    @Environment(\.modelContext) private var context
    @State private var viewModel = LineChartViewModel()
    @State private var showDates: [Date] = []
    @State private var selectedYear = Calendar.current.component(.year, from: .now)
    @State private var startMonth = 1
    @State private var endMonth = 12
    @State private var ascending = true

    private let monthNames = [
        "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ]

    private var availableYears: [Int] {
        let years = Set(showDates.map { Calendar.current.component(.year, from: $0) })
        return (years.union([Calendar.current.component(.year, from: .now)])).sorted()
    }

    private var displayedMonths: [Int] {
        // Keep the range valid during the brief state update between the two pickers.
        let months = Array(min(startMonth, endMonth)...max(startMonth, endMonth))
        return ascending ? months : Array(months.reversed())
    }

    private var chartData: [ShowsMonth] {
        displayedMonths.enumerated().map { position, month in
            let count = showDates.filter {
                let components = Calendar.current.dateComponents([.year, .month], from: $0)
                return components.year == selectedYear && components.month == month
            }.count
            return ShowsMonth(month: month, position: Double(position), count: count)
        }
    }

    private var yAxisMaximum: Int {
        chartData.map(\.count).max() ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                monthPicker(title: "De", selection: $startMonth)
                monthPicker(title: "Até", selection: $endMonth)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Ano")
                        .foregroundStyle(.white)
                    Picker("", selection: $selectedYear) {
                        ForEach(availableYears, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(.menu)
                    .fixedSize()
                    .tint(.white)
                    .foregroundStyle(.white)
                }

                Button {
                    ascending.toggle()
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .accessibilityLabel(ascending ? "Ordenar de janeiro a dezembro" : "Ordenar de dezembro a janeiro")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
            }
            .font(.caption)

            GeometryReader { geometry in
                let chartWidth = max(geometry.size.width,
                                     CGFloat(displayedMonths.count) * monthSlotWidth + 152)
                ScrollView(.horizontal) {
                    Chart(chartData) { item in
                        LineMark(
                            x: .value("Mês", item.position),
                            y: .value("Shows", item.count)
                        )
                        .foregroundStyle(Color.mainPink)
                        PointMark(
                            x: .value("Mês", item.position),
                            y: .value("Shows", item.count)
                        )
                        .foregroundStyle(Color.white)
                    }
                    // Half-slot gutters keep the first and last labels inside the plot area.
                    .chartXScale(domain: -0.5...(Double(displayedMonths.count) - 0.5))
                    // Keep the largest data point and its tick label away from the top clip edge.
                    .chartYScale(domain: 0...Double(max(yAxisMaximum + 1, 1)))
                    .chartXAxis {
                        AxisMarks(values: displayedMonths.indices.map(Double.init)) { axisValue in
                            AxisGridLine()
                                .foregroundStyle(Color.text.opacity(0.22))
                            AxisTick()
                                .foregroundStyle(Color.text.opacity(0.6))
                            AxisValueLabel {
                                if let value = axisValue.as(Double.self) {
                                    let position = Int(value.rounded())
                                    if displayedMonths.indices.contains(position) {
                                        Text(monthNames[displayedMonths[position] - 1])
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.text)
                                        .fixedSize()
                                    }
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading, values: Array(0...yAxisMaximum)) { axisValue in
                            AxisGridLine()
                                .foregroundStyle(Color.text.opacity(0.22))
                            AxisTick()
                                .foregroundStyle(Color.text.opacity(0.6))
                            AxisValueLabel {
                                let label = axisValue.as(Int.self).map { String($0) }
                                    ?? axisValue.as(Double.self).map { String(format: "%.0f", $0) }
                                    ?? ""
                                Text(label)
                                    .foregroundStyle(Color.text)
                                    .fixedSize()
                                    .padding(.leading, 8)
                            }
                        }
                    }
                    .chartXAxisLabel(position: .bottom, alignment: .center) {
                        Text("Período de tempo")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(Color.text)
                            .fixedSize()
                            .padding(.horizontal, 14)
                            .padding(.top, 12)
                    }
                    .chartYAxisLabel(position: .leading, alignment: .center) {
                        Text("Quantidade de vezes \nque foi a um show")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.text)
                            .fixedSize()
                            .lineLimit(2 )
                            .padding(.vertical, 14)
                            .padding(.horizontal, 10)
                            .rotationEffect(.degrees(180))
                    }
                    .foregroundStyle(Color.mainPink)
                    .frame(width: chartWidth, height: chartHeight)
                    .padding(.leading, 32)
                }
                .scrollIndicators(.hidden)
            }
            .frame(height: chartHeight)
        }
        .padding(.horizontal, 12)
        .task {
            showDates = viewModel.buscarDatasDosShows(context: context)
            if let latestYear = availableYears.last {
                selectedYear = latestYear
            }
        }
        .onChange(of: startMonth) { _, newValue in
            if newValue > endMonth { endMonth = newValue }
        }
        .onChange(of: endMonth) { _, newValue in
            if newValue < startMonth { startMonth = newValue }
        }
    }

    private func monthPicker(title: String, selection: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .foregroundStyle(.white)
            Picker("", selection: selection) {
                ForEach(1...12, id: \.self) { month in
                    Text(monthNames[month - 1]).tag(month)
                }
            }
            .pickerStyle(.menu)
            .fixedSize()
            .tint(.white)
            .foregroundStyle(.white)
        }
    }
}
