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
//    var event: EventEntity?
    @Attribute(.unique) var nameTitle: String
    var active: Bool
    
    init( nameTitle: String)
    {
        self.idTitle = UUID()
        self.nameTitle = nameTitle
        self.active = false
    }
}
