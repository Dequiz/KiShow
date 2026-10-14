//
//  ExperienceEntity.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 28/09/26.
//

internal import Foundation
import SwiftData

@Model

class EventEntity {
    var idEvent: UUID
    var ticketThemeRawValue: String?
    @Relationship(deleteRule: .cascade, inverse: \ShowEntity.event)
    var show: ShowEntity?
    @Relationship(deleteRule: .cascade, inverse: \ExperienceEntity.event)
        var experiences: [ExperienceEntity]?
    
    init(show: ShowEntity? = nil, ticketThemeRawValue: String = "Purple") {
        self.idEvent = UUID()
        self.ticketThemeRawValue = ticketThemeRawValue
        self.show = show
    }
}

