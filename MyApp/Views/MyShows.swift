//
//  MyShows.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//

import SwiftUI
import SwiftData
struct MyShows: View {
   
    @Query(sort: \UserEntity.idUser) var users: [UserEntity]
    
    var body: some View {
    
        if let currentUser = users.first {
            Text(currentUser.nameUser)
            Text("\(currentUser.ageUser)")
        } else {
            Text("Nenhum usuário encontrado")
        }
    }
}
