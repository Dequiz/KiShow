//
//  ExperienceEntity.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 28/09/26.
//

internal import Foundation
import SwiftData

nonisolated public enum TypeMidias: Codable, Sendable {
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
    var timeStamp: Date
    
    var textContent: [String]?
    var imageContent: [Data]?
    var videoContent: [String]?
    @Attribute(.externalStorage) var audioContent: [Data]?
    
    init (type: TypeMidias, event: EventEntity? = nil,timeStamp:Date, textContent: [String]? = nil, imageContent: [Data]? = nil, videoContent: [String]? = nil, audioContent: [Data]? = nil) {
        self.idExperience = UUID()
        self.type = type
        self.event = event
        self.timeStamp = Date()
        self.textContent = textContent
        self.imageContent = imageContent
        self.videoContent = videoContent
        self.audioContent = audioContent
    }
    
    
}
