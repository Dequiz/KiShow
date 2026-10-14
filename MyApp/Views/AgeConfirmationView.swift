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
    @Bindable var viewModel: AgeConfirmationViewModel
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
                    Text("Seu perfil está pronto")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    Text("Seus dados de perfil ficam armazenados localmente neste dispositivo.")
                        .font(.caption)
                        .fontWeight(.regular)
                        .frame(width: 255)
                }
                Spacer()
                Spacer()
                ZStack {
                    Image(.camada1)
                        .resizable()
                        .frame(width: 500, height: 250)
                        .opacity(0.3)

                    ButtonComponent(buttonText: "Começar") {
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
        .background {
            Color.clear
                .tint(.primary)
                .alert("Não foi possível criar o perfil", isPresented: $viewModel.saveFailed) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Tente novamente.")
                }
        }

    }




}
#Preview {
    @Previewable @Environment(\.modelContext) var context
    @Previewable @State var viewModel = AgeConfirmationViewModel()
    AgeConfirmationView( viewModel: viewModel)
}
