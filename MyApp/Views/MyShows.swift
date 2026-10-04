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
    
        NavigationLink(destination: EventView()){
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100,height: 100)
                .overlay{
                    Text("Show")
                }
        }
    }
}
