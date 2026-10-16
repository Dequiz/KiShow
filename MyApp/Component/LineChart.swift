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
    @Environment(\.colorScheme) var colorScheme
    private let monthSlotWidth: CGFloat = 46
    private let chartHeight: CGFloat = 190
    @Environment(\.modelContext) private var context
    @State private var viewModel = LineChartViewModel()
    @State private var showDates: [Date] = []
    @State private var failedToLoadShows = false
    @State private var selectedYear = Calendar.current.component(.year, from: .now)
    @State private var startMonth = 1
    @State private var endMonth = 12
    @State private var ascending = true

    private let monthNames = [
        "Jan", "Fev", "Mar", "Abr", "Mai", "Jun",
        "Jul", "Ago", "Set", "Out", "Nov", "Dez"
    ]

    private var availableYears: [Int] {
        let years = Set(showDates.map { Calendar.current.component(.year, from: $0) })
        return (years.union([Calendar.current.component(.year, from: .now)])).sorted()
    }

    private var displayedMonths: [Int] {
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
        VStack( spacing: 14) {
            HStack(spacing: 8) {
                monthPicker(title: "De", selection: $startMonth)
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                monthPicker(title: "Até", selection: $endMonth)
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)

                VStack(spacing: -5) {
                    Text("Ano")
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                    Picker("", selection: $selectedYear) {
                        ForEach(availableYears, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(.menu)
                    .fixedSize()
                    .tint(Color.primary)
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                }

                Button {
                    ascending.toggle()
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.primary)
                        .padding(10)
                        .glassEffect()
                }
                .accessibilityLabel(ascending ? "Ordenar de janeiro a dezembro" : "Ordenar de dezembro a janeiro")
            }
            .font(.caption)

            if failedToLoadShows {
                ContentUnavailableView(
                    "Não foi possível carregar o gráfico",
                    systemImage: "chart.xyaxis.line",
                    description: Text("Tente novamente mais tarde.")
                )
                .frame(height: chartHeight)
            } else {
                GeometryReader { geometry in
                    let minimumChartWidth = CGFloat(displayedMonths.count) * monthSlotWidth + 152
                    let chartWidth = max(geometry.size.width, minimumChartWidth + monthSlotWidth / 2)
                    ScrollView(.horizontal) {
                    Chart(chartData) { item in
                        showMarks(for: item)
                    }
                    .chartXScale(domain: -0.5...Double(displayedMonths.count))
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
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color(uiColor: .label))
                                    .fixedSize()
                                    .padding(.leading, 8)
                            }
                        }
                    }
                    .chartXAxisLabel(position: .bottom, alignment: .leading) {
                        Text("Período de tempo")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            .fixedSize()
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                    }
                    .frame(width: chartWidth, height: chartHeight)
                    .padding(.leading, 32)
                    }
                    .scrollIndicators(.hidden)
                }
                .frame(height: chartHeight)
            }
        }
        .padding(.horizontal, 12)
        .task {
            if let dates = viewModel.buscarDatasDosShows(context: context) {
                showDates = dates
                failedToLoadShows = false
            } else {
                failedToLoadShows = true
            }
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
        VStack(spacing: -5) {
            Text(title)
                .foregroundStyle(Color.primary)
            Picker("", selection: selection) {
                ForEach(1...12, id: \.self) { month in
                    Text(monthNames[month - 1]).tag(month)
                }
            }
            .pickerStyle(.menu)
            .fixedSize()
            .tint(Color.primary)
            .foregroundStyle(Color.primary)
        }
    }

    @ChartContentBuilder
    private func showMarks(for item: ShowsMonth) -> some ChartContent {
        let monthPosition: Double = item.position
        let showCount: Int = item.count

        BarMark(
            x: .value("Mês", monthPosition),
            y: .value("Shows", showCount),
            width: .fixed(14)
        )
        .foregroundStyle(Color.mainPink)

        PointMark(
            x: .value("Mês", monthPosition),
            y: .value("Shows", showCount)
        )
        .foregroundStyle(Color.primary)
    }
}
