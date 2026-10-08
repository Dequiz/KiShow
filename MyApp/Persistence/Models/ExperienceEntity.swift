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
    
    var textContent: [String]?
    var imageContent: [Data]?
    var videoContent: [String]?
    var audioContent: [Data]?
    
    init (type: TypeMidias, event: EventEntity? = nil, textContent: [String]? = nil, imageContent: [Data]? = nil, videoContent: [String]? = nil, audioContent: [Data]? = nil) {
        self.idExperience = UUID()
        self.type = type
        self.event = event
        self.textContent = textContent
        self.imageContent = imageContent
        self.videoContent = videoContent
        self.audioContent = audioContent
    }
    
    
}
