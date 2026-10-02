//
//  ProfileIcon.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 01/10/26.
//

import SwiftUI

struct ProfileIcon: View {
    let user: UserEntity?
    var size: CGFloat = 90

    var body: some View {
        Group {
            if let data = user?.photoUser, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if let name = user?.illustrationName {
                Image(name)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(Color.profileIcon)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
