//
//  InsertFromGallery.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 01/10/26.
//

import SwiftUI
import PhotosUI

struct InsertFromGallery: View {
    @State var photoSelection: PhotosPickerItem? = nil
    @State var image: Image? = nil
    
    var body: some View {
        PhotosPicker(selection: $photoSelection, matching: .images)
        {
            Group {
                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 26)
                        )
                } else {
                    Image(systemName: "photo.badge.plus")
                        .font(.title.bold())
                        .foregroundStyle(Color.mainPink)
                        .frame(width: 200, height: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .fill(
                                    Color(
                                        .secondarySystemBackground
                                    )
                                )
                                .shadow(
                                    color: Color.black.opacity(0.1),
                                    radius: 20,
                                    x: 0,
                                    y: 0
                                )
                        )
                }
            }
        }
    }
}

#Preview {
    InsertFromGallery()
}
