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
    var event: EventEntity?
    var idShow: UUID
    var nameShow: String
    var dataShow: Date
    var artistShow: String
    var genderShow: String
    var imageShow: String
    var localShow: String
    var addressShow: String
    var urlShow: String
    var startTimeShow: String
    var city: String
    var latitude: Double?
    var longitude: Double?
    
    init(nameShow: String, dataShow: Date, artistShow: String, genderShow: String, imageShow:String, localShow: String, addressShow: String, urlShow: String, startTimeShow: String, city: String, latitude: Double? = nil, longitude: Double? = nil) {
        self.idShow = UUID()
        self.nameShow = nameShow
        self.dataShow = dataShow
        self.artistShow = artistShow
        self.genderShow = genderShow
        self.imageShow = imageShow
        self.localShow = localShow
        self.addressShow = addressShow
        self.urlShow = urlShow
        self.startTimeShow = startTimeShow
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
    }
}
