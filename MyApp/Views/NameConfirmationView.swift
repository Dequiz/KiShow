//
//  NameConfirmationView.swift
//  MyApp
//
//  Created by Andre on 30/09/26.
//

import SwiftUI
import SwiftData

struct NameConfirmationView: View {
    enum Field {
        case name
    }
    @FocusState private var focusedField: Field?
    @Environment(\.modelContext) var context
    @State private var viewModel = AgeConfirmationViewModel()
    @State var isAble = false
    var body: some View{
       
        NavigationStack{
            ZStack{
                Color.appBackground
                VStack{
                    Spacer()
                    VStack(spacing: 10){
                        Text("Nos diga como quer ser chamado(a)")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Seu nome será usado somente internamente no aplicativo para apresentação do seu perfil")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 70)
                    }
                    Spacer()
                    TextField("Ex: Maria", text: $viewModel.username)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .foregroundStyle(Color.primary)
                        .tint(.mainPink)
                        .clipShape(.capsule)
                        .focused($focusedField, equals: .name)
                    Spacer()
                    ZStack {
                        Image(.camada1)
                            .resizable()
                            .frame(width: 500, height: 250)
                            .opacity(0.3)

                        ButtonComponent(buttonText: "Começar") {
                                viewModel.saveUser(username: viewModel.username, context: context)
                            }
                            .disabled(viewModel.username.isEmpty)
                            .glassEffect(viewModel.username.isEmpty ? .clear.tint(.mainPink.opacity(0.5)) : .clear.tint(.mainPink))
                    }
                    }
                }.onTapGesture {
                    focusedField = nil
                }
            .ignoresSafeArea()
            }
        .navigationDestination(isPresented: $viewModel.navigateToNextScreen) {
            ContentView()
        }
        }
    }


#Preview {
    NameConfirmationView(isAble: false)
}
