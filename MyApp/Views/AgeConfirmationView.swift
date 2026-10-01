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
                    Text("Seu nome somente será usado internamente no aplicativo para apresentação do seu perfil")
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
                ButtonComponent(buttonText: "Continuar"){
                    viewModel.saveUser(username: viewModel.username, context: modelContext)
                }
                Spacer()
                
            }
            
        }
        .ignoresSafeArea()
        .navigationDestination(isPresented: $viewModel.navigateToNextScreen) {
            ContentView()
        }
        
    }
    
    
    
   
}
