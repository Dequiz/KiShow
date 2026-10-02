//
//  BulletTopic.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 02/10/26.
//

import SwiftUI

struct BulletTopic: View {
    var text: String
    var body: some View {
        HStack{
            Image(systemName: "circle.fill")
                .font(.system(size:6))
                .foregroundStyle(.mainPurple.opacity(0.5))
            
            Text(text)
        }
    }
}

#Preview {
    BulletTopic(text: "kjkjbjk")
}
