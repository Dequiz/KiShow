//
//  NameConfirmationView.swift
//  MyApp
//
//  Created by Andre on 30/09/26.
//

import SwiftUI

struct NameConfirmationView: View {
    @State private var viewModel = AgeConfirmationViewModel()
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
                        Text("Nos diga como quer ser chamado(a)")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        Text("Seu nome será usado somente internamente no aplicativo para apresentação do seu perfil")
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
                    Spacer()
                    Image(.camada1)
                        .resizable()
                        .frame(width:500,height: 250)
                        .rotationEffect(.degrees(0))
                        .opacity(0.3)
                        .overlay{
                            NavigationLink(destination: AgeConfirmationView(viewModel: viewModel)) {
                                HStack{
                                    Text("Continuar")
                                    Image(systemName: "chevron.right")
                                }
                                
                                .foregroundStyle(Color.white)
                                .frame(width: 300,height: 44)
                                .clipShape(.capsule)
                            }
                           .disabled(viewModel.username.isEmpty)
                           .glassEffect(viewModel.username.isEmpty ? .clear.tint(.mainPink.opacity(0.5)) : .clear.tint(.mainPink))
                        }
                    }
                }
            .ignoresSafeArea()
            }
        }
    }


#Preview {
    let viewModel = AgeConfirmationViewModel()
    NameConfirmationView(isAble: false)
}
