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
        case music
    }
    //Funçao que salva as imagens inseridos como mídia primaria no app
    func saveExperience(description: String,content: Data,mediaType: TypeMidias, context: ModelContext){
        if mediaType == .image && content.isEmpty{
            return
        }
        let newExperience = (ExperienceEntity(type: mediaType,textContent: description,imageContent: [content]))
        context.insert(newExperience)
    }
    //Funçao que salva os vídeos inseridos como mídia primaria no app

    func saveExperience(description: String,content: [String],mediaType: TypeMidias, context: ModelContext){
        if mediaType == .image && content.isEmpty{
            return
        }
        let newExperience = (ExperienceEntity(type: mediaType,textContent: description,videoContent: content))
        context.insert(newExperience)
    }
    
    
    //Funçao que salva os áudios inseridos como mídia primaria no app
    func saveExperience(description: String,content: [Data],mediaType: TypeMidias, context: ModelContext){
        if mediaType == .image && content.isEmpty{
            return
        }
        let newExperience = (ExperienceEntity(type: mediaType,textContent: description,audioContent: content))
        context.insert(newExperience)
    }
    
}
