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
    var nameTitle: String
    
    init( nameTitle: String)
    {
        self.idTitle = UUID()
        self.nameTitle = nameTitle
    }
}
