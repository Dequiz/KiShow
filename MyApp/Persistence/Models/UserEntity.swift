//
//  UserEntity.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 28/09/26.
//

import Foundation
import SwiftData

@Model

class UserEntity {
    var idUser: UUID
    var nameUser: String
    var photoUser: Data?
    var illustrationName: String?
    var ageUser: Int
    var title: TitleEntity?
    var show: ShowEntity?
    
    init(nameUser: String, photoUser: Data? = nil, illustrationName: String? = nil,  ageUser: Int, title: TitleEntity? = nil, show: ShowEntity? = nil)
    {
        self.idUser = UUID()
        self.nameUser = nameUser
        self.photoUser = photoUser
        self.illustrationName = illustrationName
        self.ageUser = ageUser
        self.title = title
        self.show = show
    }
}
