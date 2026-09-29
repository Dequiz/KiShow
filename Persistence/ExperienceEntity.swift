//
//  ExperienceEntity.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 28/09/26.
//

import Foundation
import SwiftData

public enum TypeMidias: Codable {
    case image
    case video
    case audio
    case text
}

@Model
class ExperienceEntity {
    var idExperience: UUID
    var type: TypeMidias
    var event: EventEntity?
    
    var textContent: String?
    var imageContent: [Data]?
    var videoContent: [Data]?
    var audioContent: [Data]?
    
    init (idExperience: UUID = UUID(), type: TypeMidias, event: EventEntity? = nil, textContent: String? = nil, imageContent: [Data]? = nil, videoContent: [Data]? = nil, audioContent: [Data]? = nil) {
        self.idExperience = idExperience
        self.type = type
        self.event = event
        self.textContent = textContent
        self.imageContent = imageContent
        self.videoContent = videoContent
        self.audioContent = audioContent
    }
    
    
}
