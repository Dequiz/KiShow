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
    var navigateToNextScreen = false
    var saveFailed = false
    var username = ""
    
    func saveUser(username: String, context: ModelContext) {
        let displayName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !displayName.isEmpty else { return }
        // Keep the existing SwiftData field for backward-compatible schema storage.
        let newUser = UserEntity(nameUser: displayName, ageUser: 0)
        
        context.insert(newUser)
        
        do {
            try context.save()
            navigateToNextScreen = true
        } catch {
            context.delete(newUser)
            navigateToNextScreen = false
            saveFailed = true
        }
    }
}
