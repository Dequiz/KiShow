//
//  InsertFromGallery.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 01/10/26.
//
import SwiftUI
import PhotosUI

struct InsertFromGallery: View {
    @Binding var selection: ProfilePhotoSelection?
    @State private var photoSelected: PhotosPickerItem?
    
    private var previewImage: UIImage? {
        if case .gallery(let data) = selection {
            return UIImage(data: data)
        }
        return nil
    }

    var body: some View {
        PhotosPicker(selection: $photoSelected, matching: .images) {
            VStack {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                      .scaledToFill()
                      .frame(width: 200, height: 200)
                      .clipShape(RoundedRectangle(cornerRadius: 26))
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    }
                    .font(.title.bold())
                    .foregroundStyle(Color.mainPink)
                    .frame(width: 200, height: 200)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 26))
                }
            }
        }
        .buttonStyle(.plain)
        .task(id: photoSelected) {
            guard let photoSelected else { return }
            if let data = try? await photoSelected.loadTransferable(type: Data.self) {
                selection = .gallery(data)
            }
        }
    }
}

