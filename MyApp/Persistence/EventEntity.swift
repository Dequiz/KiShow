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
    var show: ShowEntity?
    @Relationship(deleteRule: .cascade, inverse: \ExperienceEntity.event)
        var experiences: [ExperienceEntity]?
    
    init( idEvent: UUID, show:ShowEntity? = nil) {
        self.idEvent = idEvent
        self.show = show
    }
}

