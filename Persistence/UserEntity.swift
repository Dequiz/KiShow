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
    var ageUser: Int
    var idTitle: TitleEntity
    var idShow: ShowEntity
    
    init(idUser: UUID, nameUser: String, ageUser: Int, idTitle: TitleEntity, idShow: ShowEntity)
    {
        self.idUser = idUser
        self.nameUser = nameUser
        self.ageUser = ageUser
        self.idTitle = idTitle
        self.idShow = idShow
    }
}
