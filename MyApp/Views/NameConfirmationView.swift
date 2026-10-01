//
//  NameConfirmationView.swift
//  MyApp
//
//  Created by Andre on 30/09/26.
//

import SwiftUI

struct NameConfirmationView: View {
    @State private var viewModel = AgeConfirmationViewModel()
    @State var surname = ""
    @State var isAble = false
    var body: some View{
       
        NavigationStack{
            ZStack{
                Color.appBackground
                VStack{
                    Spacer()
                    HStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.mainPink)
                            .frame(width:80,height: 10)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width:80,height: 10)
                            .foregroundStyle(.mainPink.opacity(0.5))
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Nos diga seu nome")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        Text("Seu nome somente será usado internamente no aplicativo para apresentação do seu perfil")
                            .font(.caption)
                            .fontWeight(.regular)
                            .frame(width: 255)
                    }
                    Spacer()
                    TextField("Ex: Maria",text: $viewModel.username)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                    TextField("Ex: Clara",text: $surname)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                    Spacer()
                    NavigationLink(destination: AgeConfirmationView(viewModel: viewModel)) {
                        HStack{
                            Text("Continuar")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(Color.white)
                        .frame(width: 300,height: 44)
                        .clipShape(.capsule)
                    }.glassEffect(.clear.tint(viewModel.username.isEmpty || surname.isEmpty ? .mainPink.opacity(0.6) : .mainPink))
                        .disabled(viewModel.username.isEmpty || surname.isEmpty)
                    Spacer()
                    }
                }
            .ignoresSafeArea()
            }
        }
    }


