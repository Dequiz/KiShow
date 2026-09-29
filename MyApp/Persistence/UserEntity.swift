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
    var title: TitleEntity?
    var show: ShowEntity?
    
    init(idUser: UUID, nameUser: String, ageUser: Int, title: TitleEntity? = nil, show: ShowEntity? = nil)
    {
        self.idUser = idUser
        self.nameUser = nameUser
        self.ageUser = ageUser
        self.title = title
        self.show = show
    }
}
