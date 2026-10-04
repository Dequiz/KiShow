//
//  InsertCategoryIlustrations.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 01/10/26.
//

import SwiftUI

struct InsertCategoryIlustrations: View {
    
    var categoryNames: CategoryNames
    @Binding var selection: ProfilePhotoSelection?
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(categoryNames.categoryNames, id: \.self) { category in
                    Button {
                        selection = .illustration(category)
                    } label: {
                        Image(category)
                            .resizable()
                            .scaledToFit()
    
                    }
                }
            }
            .padding(20)
        }
        
    }
    
}
