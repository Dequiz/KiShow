//
//  TitleEntity.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 28/09/26.
//

import Foundation
import SwiftData

@Model

class TitleEntity {
    var idTitle: UUID
    var idEvent: EventEntity
    var nameTitle: String
    
    init(idTitle: UUID, idEvent: EventEntity, nameTitle: String)
    {
        self.idTitle = idTitle
        self.idEvent = idEvent
        self.nameTitle = nameTitle
    }
}
