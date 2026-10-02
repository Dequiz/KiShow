//
//  ProfilePhotoSelection.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 01/10/26.
//

import SwiftUI

enum ProfilePhotoSelection: Equatable {
    case gallery(Data)
    case illustration(String)
    
    func apply(to user: UserEntity) {
        switch self {
        case .gallery(let data):
            user.photoUser = data
            user.illustrationName = nil
        case .illustration(let name):
            user.illustrationName = name
            user.photoUser = nil
        }
    }
    
    
}
