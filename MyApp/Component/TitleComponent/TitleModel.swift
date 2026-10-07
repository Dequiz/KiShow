//
//  TitleModel.swift
//  MyApp
//
//  Created by Andre on 06/10/26.
//
import Foundation
struct TitleModel{
    var id : UUID
    var title: String
    var active: Bool = false
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}
