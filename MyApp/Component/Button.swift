//
//  Button.swift
//  MyApp
//
//  Created by Andre on 30/09/26.
//

import SwiftUI

struct ButtonComponent: View {
    var buttonText: String
    var textWeight: Font.Weight = .regular
    var colorButton: Color = .mainPink
    var buttonIcon: String = ""
    var colorText : Color = .white
    let functionality : () -> Void
    var paddingButton : Int = 10
    var widthButton : Int = 300
    var heightButton : Int = 44
   
   
    
    var body: some View {
        Button(action: functionality) {
            HStack(){
                Text(buttonText)
                    .fontWeight(textWeight)
                    .foregroundStyle(colorText)
                Image(systemName: "chevron.right")
                    .foregroundColor(colorText)
            }
        }
        .frame(width: CGFloat(widthButton),height: CGFloat(heightButton))
        .background(.mainPink)
        .clipShape(.capsule)
    }
}

#Preview {
    ButtonComponent(buttonText: "Clicar"){
        print("Cliquei")
    }
}
