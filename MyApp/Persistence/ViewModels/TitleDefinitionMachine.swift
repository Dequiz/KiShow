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
    func processAction(_ action: UserAction,context: ModelContext){
        switch action{
        case .secretButtonClicked(let clickButton):
            if clickButton >= 3{
                unlockTitle(texto: "Super Mary", context: context)
                unlockTitle(texto: "Super Andre", context: context)
                unlockTitle(texto: "Super Elisa", context: context)
                unlockTitle(texto: "Super Paulo", context: context)
            }
        case .showRegistered(let totalShows ):
            if totalShows >= 5{
                unlockTitle(texto: "Colecionador", context: context)
            }
            if totalShows >= 1{
                unlockTitle(texto: "Colecionador Novato", context: context)
            }
        case .photosAdded(let totalPhotos):
            if totalPhotos >= 3{
                unlockTitle(texto: "Fotografo", context: context)
            }
        case .textAdded(let totalText):
            if totalText >= 1{
                unlockTitle(texto: "Escritor Jr", context: context)
            }
            if totalText >= 1000{
                unlockTitle(texto: "Escritor", context: context)
            }
        }
    }
    
    func unlockTitle(texto: String, context: ModelContext) {
        let descriptor = FetchDescriptor<TitleEntity>(
            predicate: #Predicate { $0.nameTitle == texto }
        )
        do {
            let count = try context.fetchCount(descriptor)
            if count == 0 {
                context.insert(TitleEntity(nameTitle: texto))
                try context.save()
            } else {
                print("O título '\(texto)' já foi desbloqueado anteriormente.")
            }
        } catch {
            print("Erro ao desbloquear título: \(error)")
        }
    }
    
    
    
}
