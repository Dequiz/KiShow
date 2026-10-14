//
//  AgeConfirmationViewModel.swift
//  MyApp
//
//  Created by Andre on 30/09/26.
//

import SwiftUI
import SwiftData

@Observable
class AgeConfirmationViewModel {
    var daySelected = 1
    var monthSelected = 1
    var yearSelected = 2006
    var navigateToNextScreen = false
    var username = ""
    
    func saveUser(username: String, context: ModelContext) {
        let displayName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !displayName.isEmpty,
              let age = calcularIdade(day: daySelected, month: monthSelected, year: yearSelected) else {
            return
        }
        let newUser = UserEntity(nameUser: displayName, ageUser: age)
        
        context.insert(newUser)
        
        do {
            try context.save()
            navigateToNextScreen = true
        } catch {
            print("Erro ao salvar utilizador: \(error.localizedDescription)")
        }
    }
    
    private func calcularIdade(day: Int, month: Int, year: Int) -> Int? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        guard let birthDate = Calendar.current.date(from: components),
              Calendar.current.component(.year, from: birthDate) == year,
              Calendar.current.component(.month, from: birthDate) == month,
              Calendar.current.component(.day, from: birthDate) == day,
              birthDate <= Date.now else {
            return nil
        }
        return Calendar.current.dateComponents([.year], from: birthDate, to: .now).year
    }
}
