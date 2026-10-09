//
//  ExperienceViewModel.swift
//  MyApp
//
//  Created by Andre on 01/10/26.
//

import SwiftUI
import SwiftData

@Observable
class ExperienceViewModel{
    var media = MediaTypes.text
    
    enum MediaTypes : String{
        case text
        case photo
        case video
        case audio
    }
    
    func saveExperience(event: EventEntity,description: [String],content: String,mediaType: TypeMidias, context: ModelContext){
        if mediaType == .image && content.isEmpty{
            return
        }
        let newExperience = (ExperienceEntity(type: mediaType,event: event,textContent: description))
        context.insert(newExperience)
    }
    
    //Funçao que salva as imagens inseridos como mídia primaria no app
    func saveExperience(event: EventEntity,description: [String],content: Data,mediaType: TypeMidias, context: ModelContext){
        if mediaType == .image && content.isEmpty{
            return
        }
        let newExperience = (ExperienceEntity(type: mediaType,event: event,textContent: description,imageContent: [content]))
        context.insert(newExperience)
    }
    //Funçao que salva os vídeos inseridos como mídia primaria no app

    func saveExperience(event: EventEntity,description: [String],content: [String],mediaType: TypeMidias, context: ModelContext){
        if mediaType == .image && content.isEmpty{
            return
        }
        let newExperience = (ExperienceEntity(type: mediaType,event: event,textContent: description,videoContent: content))
        context.insert(newExperience)
    }
    
    
    //Funçao que salva os áudios inseridos como mídia primaria no app
    func saveExperience(event: EventEntity,description: [String],content: [Data],mediaType: TypeMidias, context: ModelContext){
        guard mediaType == .audio, let audioData = content.first, !audioData.isEmpty else {
            return
        }
        let newExperience = ExperienceEntity(type: mediaType, event: event, textContent: description, audioContent: [audioData])
        context.insert(newExperience)
        do {
            try context.save()
        } catch {
            context.delete(newExperience)
            print("Audio persistence failed: \(error)")
        }
    }
    
}
