//
//  CustomDatePicker.swift
//  MyApp
//
//  Created by Andre on 30/09/26.
//

import SwiftUI


struct CustomDatePicker: View {
    @Binding var selectedDay: Int
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int

    private var latestSelectableMonth: Int {
        selectedYear == Calendar.current.component(.year, from: .now)
            ? Calendar.current.component(.month, from: .now)
            : 12
    }

    private var daysInSelectedMonth: Int {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = 1
        guard let date = Calendar.current.date(from: components),
              let range = Calendar.current.range(of: .day, in: .month, for: date) else {
            return 31
        }
        let lastDay = range.count
        let calendar = Calendar.current
        if selectedYear == calendar.component(.year, from: .now),
           selectedMonth == calendar.component(.month, from: .now) {
            return min(lastDay, calendar.component(.day, from: .now))
        }
        return lastDay
    }
  
    var body: some View {
        HStack{
            VStack(){
                Text("Dia")
                    .font(.headline)
                Picker("Dia",selection: $selectedDay){
                    
                    ForEach(1...daysInSelectedMonth, id: \.self){ day in
                        Text("\(day)").tag(day)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .frame(height: 150)

            VStack(){
                Text("Mês")
                    .font(.headline)
                Picker("Mês",selection: $selectedMonth){
                    
                    ForEach(1...latestSelectableMonth, id: \.self){ month in
                        Text("\(month)").tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .frame(height: 150)

            VStack(){
                Text("Ano")
                    .font(.headline)
                Picker("Ano",selection: $selectedYear){
                    
                    ForEach(1900...Calendar.current.component(.year, from: Date()), id: \.self){ year in
                        Text(String("\(year)")).tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .frame(height: 150)
        }
        .onChange(of: selectedMonth) { _, _ in
            selectedDay = min(selectedDay, daysInSelectedMonth)
        }
        .onChange(of: selectedYear) { _, _ in
            selectedMonth = min(selectedMonth, latestSelectableMonth)
            selectedDay = min(selectedDay, daysInSelectedMonth)
        }
    }
}

//#Preview {
//    CustomDatePicker()
//}
