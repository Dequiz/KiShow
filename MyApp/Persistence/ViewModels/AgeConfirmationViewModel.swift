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
        let age = verificarIdade(day: daySelected, month: monthSelected, year: yearSelected)
        let newUser = UserEntity(nameUser: username, ageUser: age)
        
        context.insert(newUser)
        
        do {
            try context.save()
            navigateToNextScreen = true
        } catch {
            print("Erro ao salvar utilizador: \(error.localizedDescription)")
        }
    }
    
    private func verificarIdade(day: Int, month: Int, year: Int) -> Int {
        let atualDate = Calendar.current
        let atualDay = atualDate.component(.day, from: Date())
        let atualMonth = atualDate.component(.month, from: Date())
        let atualYear = atualDate.component(.year, from: Date())
        
        var idade = atualYear - year
        
        if atualMonth < month || (atualMonth == month && atualDay < day) {
            idade -= 1
        }
        
        return idade
    }
}
