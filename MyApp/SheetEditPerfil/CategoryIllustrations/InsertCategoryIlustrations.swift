//
//  InsertCategoryIlustrations.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 01/10/26.
//

import SwiftUI

struct InsertCategoryIlustrations: View {
    
    var categoryNames: CategoryNames
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(categoryNames.categoryNames, id: \.self) { category in
                        Button {
                         
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
    
}

#Preview {
    InsertCategoryIlustrations(categoryNames: CategoryNames())
}
