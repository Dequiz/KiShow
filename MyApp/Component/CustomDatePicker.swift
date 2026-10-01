//
//  CustomDatePicker.swift
//  MyApp
//
//  Created by Andre on 30/09/26.
//

import SwiftUI


struct CustomDatePicker: View {
    var dateDay = Calendar.current.component(.day, from: Date())
    @Binding var selectedDay: Int
        @Binding var selectedMonth: Int
        @Binding var selectedYear: Int
  
    var body: some View {
        HStack{
            VStack(){
                Text("Dia")
                    .font(.headline)
                Picker("Dia",selection: $selectedDay){
                    
                    ForEach(1...31, id: \.self){ day in
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
                    
                    ForEach(1...12, id: \.self){ day in
                        Text("\(day)").tag(day)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .frame(height: 150)

            VStack(){
                Text("Dia")
                    .font(.headline)
                Picker("Dia",selection: $selectedYear){
                    
                    ForEach(1900...Calendar.current.component(.year, from: Date()), id: \.self){ day in
                        Text(String("\(day)")).tag(day)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .frame(height: 150)
        }
        Button {
            print("\(selectedDay)-\(selectedMonth)-\(selectedYear)")
        } label: {
            Text("Teste Dia")
        }.buttonStyle(.borderedProminent)

    }
}

//#Preview {
//    CustomDatePicker()
//}
