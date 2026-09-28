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
    var idShow: ShowEntity
    var idExperience: ExperienceEntity
    
    init( idEvent: UUID, idShow:ShowEntity, idExperience: ExperienceEntity) {
        self.idEvent = idEvent
        self.idShow = idShow
        self.idExperience = idExperience
    }
}

