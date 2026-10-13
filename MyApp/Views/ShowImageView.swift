//
//  ShowImageView.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 13/10/26.
//

import SwiftUI

struct ShowImageView: View {
    let data: Data?
    var placeholderHeight: CGFloat = 200

    var body: some View {
        Group {
            if let data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    Image(systemName: "music.note")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
