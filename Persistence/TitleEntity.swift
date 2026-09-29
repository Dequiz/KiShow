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
    var event: EventEntity?
    var nameTitle: String
    
    init(idTitle: UUID, event: EventEntity? = nil, nameTitle: String)
    {
        self.idTitle = idTitle
        self.event = event
        self.nameTitle = nameTitle
    }
}
