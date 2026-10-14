//
//  TitleDefinitionMachine.swift
//  MyApp
//
//  Created by Andre on 06/10/26.
//

import SwiftUI
import SwiftData
@Observable
class TitleDefinitionMachine{
    var disponibleTitles = TitleViewModel()
    enum UserAction{
        case secretButtonClicked(clickButton: Int)
            case showRegistered(totalShows: Int)
        case photosAdded(totalPhotos: Int)
        case textAdded(totalText: Int)
    }
     var titleVm = TitleViewModel()
    func processAction(_ action: UserAction, context: ModelContext) throws -> [String] {
        var newlyUnlocked: [String] = []

        switch action{
        case .secretButtonClicked(let clickButton):
            if clickButton >= 3{
                for title in ["Super Mary", "Super Andre", "Super Elisa", "Super Paulo"] {
                    if try unlockTitle(texto: title, context: context) { newlyUnlocked.append(title) }
                }
            }
        case .showRegistered(let totalShows ):
            if totalShows > 10 {
                if try unlockTitle(texto: "Dono", context: context) { newlyUnlocked.append("Dono") }
            }
            if totalShows >= 5{
                if try unlockTitle(texto: "Colecionador", context: context) { newlyUnlocked.append("Colecionador") }
            }
            if totalShows >= 1{
                if try unlockTitle(texto: "Colecionador Novato", context: context) { newlyUnlocked.append("Colecionador Novato") }
            }
        case .photosAdded(let totalPhotos):
            if totalPhotos >= 3{
                if try unlockTitle(texto: "Fotografo", context: context) { newlyUnlocked.append("Fotografo") }
            }
        case .textAdded(let totalText):
            if totalText >= 1{
                if try unlockTitle(texto: "Escritor Jr", context: context) { newlyUnlocked.append("Escritor Jr") }
            }
            if totalText >= 1000{
                if try unlockTitle(texto: "Escritor", context: context) { newlyUnlocked.append("Escritor") }
            }
        }
        return newlyUnlocked
    }
    
    func unlockTitle(texto: String, context: ModelContext) throws -> Bool {
        let descriptor = FetchDescriptor<TitleEntity>(
            predicate: #Predicate { $0.nameTitle == texto }
        )
        let count = try context.fetchCount(descriptor)
        guard count == 0 else { return false }

        context.insert(TitleEntity(nameTitle: texto))
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            throw error
        }
    }
    

    
}
