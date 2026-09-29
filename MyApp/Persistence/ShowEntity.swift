//
//  ShowEntity.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 28/09/26.
//

import Foundation
import SwiftData

@Model

class ShowEntity {
    var idShow: UUID
    var nameShow: String
    var dataShow: Date
    var artistShow: String
    var genderShow: String
    var imageShow: String
    var localShow: String
    
    init(idShow: UUID, nameShow: String, dataShow: Date, artistShow: String, genderShow: String, imageShow:String, localShow: String ) {
        self.idShow = idShow
        self.nameShow = nameShow
        self.dataShow = dataShow
        self.artistShow = artistShow
        self.genderShow = genderShow
        self.imageShow = imageShow
        self.localShow = localShow
    }
}
