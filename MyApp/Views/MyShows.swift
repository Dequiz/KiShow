//
//  MyShows.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//

import SwiftUI
import SwiftData
struct MyShows: View {
    var body: some View {
        ZStack{
            Color("AppBackground")
                .ignoresSafeArea()
            NavigationStack{
                NavigationLink(destination: EventView()){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100,height: 100)
                        .overlay{
                            Text("Show")
                        }
                }
                NavigationLink(destination: EventView()) {
                    Circle()
                        .frame(width: 150,height: 150)
                        .tint(.blueText)
                    
                }
            }
        }
    }
}
