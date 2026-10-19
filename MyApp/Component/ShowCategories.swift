//
//  ShowCategories.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 15/10/26.
//

import SwiftUI

struct ShowCategories: View {
    var categoryName: String
    var categoryImage: ImageResource
    
    
    var body: some View {
        VStack {
            Image(categoryImage)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                                Text(categoryName)
                                    .font(.system(.title2, weight: .bold))
                                    .foregroundColor(.primary)
                                    .offset(y: 20)

                            }
        }
    }
}

#Preview {
    ShowCategories(categoryName: "Pop", categoryImage: .pop)
}
