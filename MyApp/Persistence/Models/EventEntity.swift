//
//  ExperienceEntity.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 28/09/26.
//

import Foundation
import SwiftData

@Model

class EventEntity {
    var idEvent: UUID
    @Relationship(deleteRule: .cascade, inverse: \ShowEntity.event)
    var show: ShowEntity?
    @Relationship(deleteRule: .cascade, inverse: \ExperienceEntity.event)
        var experiences: [ExperienceEntity]?
    
    init(show:ShowEntity? = nil) {
        self.idEvent = UUID()
        self.show = show
    }
}

