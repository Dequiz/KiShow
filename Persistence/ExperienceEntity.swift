//
//  ExperienceEntity.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 28/09/26.
//

import Foundation
import SwiftData

public enum typeMidias: Codable {
    case image
    case video
    case audio
    case text
}

@Model
class ExperienceEntity {
    var type: typeMidias
    var idEvent: EventEntity
    
    var textContent: String
    var imageContent: [Data]?
    var videoContent: [Data]?
    var audioContent: [Data]?
    
    init (type: typeMidias, textContent: String, imageContent: [Data], videoContent: [Data], audioContent: [Data]) {
        self.type = type
        self.textContent = textContent
        self.imageContent = imageContent
        self.videoContent = videoContent
        self.audioContent = audioContent
    }
    
    
}
