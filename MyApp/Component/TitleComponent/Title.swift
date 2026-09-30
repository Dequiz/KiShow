//
//  Title.swift
//  MyApp
//
//  Created by Andre on 29/09/26.
//

import SwiftUI

struct Title: View{
    var titleNames : TitlesNames
    @State var upSheet = false
    @State var presentedTitle = "Escolha Seu Título"
    
    var body: some View{
        Button{
            upSheet.toggle()
        }label: {
            HStack{
                        Text(presentedTitle)
                    .foregroundStyle(Color.secondary)
                            .padding(10)
                   .glassEffect()
                   .shadow(radius: 1)
                   
                Image(systemName: "pencil.line")
            }
            
        }
        .sheet(isPresented: $upSheet){
            HStack{
                Text("Escolha Seu Titulo")
                    .font(.title)
                    .padding(30)
                Spacer()
            }
                ForEach(titleNames.titleNames,id: \.self){ titulo in
                    Button{
                        presentedTitle = titulo
                        upSheet = false
                    }label: {
                        Text(titulo)
                            .frame(width: 150)
                            .padding()
                            .background(Color.blue)
                            .clipShape(.capsule)
                            .foregroundStyle(Color.white)
                            .shadow(radius: 10)
                    }
                }
            }
        }
        }
#Preview {
    Title(titleNames: TitlesNames())
}
