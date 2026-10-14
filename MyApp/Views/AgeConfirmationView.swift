//
//  AgeConfirmationView.swift
//  MyApp
//
//  Created by Andre on 30/09/26.
//
import SwiftData
import SwiftUI

struct AgeConfirmationView: View {
    @Environment(\.modelContext) private var modelContext
    @State  var viewModel : AgeConfirmationViewModel
    var body: some View {
        ZStack{
            Color.appBackground
            VStack{
                Spacer()
                HStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.mainPink.opacity(0.5))
                        .frame(width:80,height: 10)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width:80,height: 10)
                        .foregroundStyle(.mainPink)
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("Nos diga sua data de nascimento")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    Text("A data do seu nascimento será utilizada somente internamente no aplicativo para apresentação do seu perfil")
                        .font(.caption)
                        .fontWeight(.regular)
                        .frame(width: 255)
                }
                Spacer()
                CustomDatePicker(
                    selectedDay: $viewModel.daySelected,
                    selectedMonth: $viewModel.monthSelected,
                    selectedYear: $viewModel.yearSelected
                )
                Spacer()
                Image(.camada1)
                    .resizable()
                    .frame(width:500,height: 250)
                    .rotationEffect(.degrees(0))
                    .opacity(0.3)
                    .overlay{
                        ButtonComponent(buttonText: "Continuar"){
                            viewModel.saveUser(username: viewModel.username, context: modelContext)
                        }
                       .disabled(viewModel.username.isEmpty)
                       .glassEffect(viewModel.username.isEmpty ? .clear.tint(.mainPink.opacity(0.5)) : .clear.tint(.mainPink))
                    }
            }
            
        }
        .ignoresSafeArea()
        .navigationDestination(isPresented: $viewModel.navigateToNextScreen) {
            ContentView()
        }
        
    }
    
    
    
   
}
