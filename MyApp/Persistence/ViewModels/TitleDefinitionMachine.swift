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
    
    enum UserAction{
            case secretButtonClicked
            case showRegistered(totalShows: Int)
    }
     var titleVm = TitleViewModel()
    
    func verifyCondition(_ action: UserAction,context: ModelContext){
        switch action{
        case .secretButtonClicked:
            unlockTitle(texto: "Colecionador", context: context)
        case .showRegistered(totalShows: let totalShows):
            break
        default:
            break
            
        }
    }
    
    func unlockTitle(texto: String,context: ModelContext){
        let fetchDescriptor = FetchDescriptor<TitleEntity>(
                    predicate: #Predicate { $0.nameTitle == texto }
                )
                do {
                    let count = try context.fetchCount(fetchDescriptor)
                        if count == 0 {
                        titleVm.setTitleActive(texto: texto)
                        let unlockingTitle = TitleEntity(nameTitle: texto)
                        context.insert(unlockingTitle)
                    } else {
                        print("O título '\(texto)' já foi desbloqueado anteriormente.")
                    }
                } catch {
                    print("Erro ao verificar duplicatas no SwiftData: \(error)")
                }
    }
    
    
    
}
