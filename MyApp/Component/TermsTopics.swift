//
//  TermsTopics.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 02/10/26.
//

import SwiftUI

struct TermsTopics: View {
    @State var numberTerm:String
    
    var body: some View {
    
        Text(numberTerm)
            .font(.footnote)
            .fontWeight(.bold)
            .padding(10)
            .background(Color.mainPurple.opacity(0.5))
            .clipShape(.circle)
            .foregroundStyle(Color.white)
    }
}

#Preview {
    TermsTopics(numberTerm: "1")
}
