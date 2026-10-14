//
//  AboutTheApp.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI
import SwiftData
import SimpleToast

struct AboutTheApp: View {
    @State var dm = TitleDefinitionMachine()
    @State var countButtonClick = 0
    @Environment(\.modelContext) var context
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastSucceeded = false
    private let toastOption = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

    private var appVersion: String {
        let info = Bundle.main.infoDictionary ?? [:]
        let version = info["CFBundleShortVersionString"] as? String ?? "—"
        let build = info["CFBundleVersion"] as? String ?? "—"
        return "\(version) (\(build))"
    }
    var body: some View {
        ZStack (alignment: .top){
            Color("AppBackground")
                .ignoresSafeArea()
            ScrollView {
                ZStack{
                    VStack (alignment: .leading){
                        Text("O Kishow foi desenvolvido para ajudar você a procurar shows disponíveis na TicketMaster e, a partir deles, adicionar registros de suas experiências com seus próprios comentários, vídeos, imagens e áudios. Nosso objetivo é oferecer uma experiência prática, segura e intuitiva para revisitar as suas memórias.")
                        
                        Spacer()
                        
                        Text("Informações do sistema")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        
                        Text("**Versão:** \(appVersion)")
                        Text("**Desenvolvido por:** Paulo Eduardo Barbosa da Silva, André Holovati, Maria Clara Fernandes Bessa e Elisa Tanada Giacomini da Silva.")
                        
                        Spacer()
                        
                        Button{
                            countButtonClick += 1
                        } label: {
                            Image("ArtGroup")
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 320, minHeight: 320)
                        }
                       
                        
                        Spacer()
                        
                        Text("Última atualização: 06/10/2026")
                            .foregroundStyle(Color.secondary)
                            .font(.callout)
                            .padding(.top)
                    }
                    .padding(20)
                }
                .navigationTitle("Sobre o Aplicativo")
                .toolbarTitleDisplayMode(.inline)
            }
        }
        .task(id: countButtonClick) {
            do {
                let unlocked = try dm.processAction(
                    .secretButtonClicked(clickButton: countButtonClick),
                    context: context
                )
                guard !unlocked.isEmpty else { return }
                toastMessage = "Conquistas desbloqueadas: \(unlocked.joined(separator: ", "))."
                toastSucceeded = true
            } catch {
                toastMessage = "Não foi possível desbloquear as conquistas. \(error.localizedDescription)"
                toastSucceeded = false
            }
            showToast = !toastMessage.isEmpty
        }
        .simpleToast(isPresented: $showToast, options: toastOption) {
            HStack(spacing: 10) {
                Image(systemName: toastSucceeded ? "checkmark.circle" : "exclamationmark.triangle")
                Text(toastMessage)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .background(toastSucceeded ? Color.mainPurple : Color.red)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .frame(maxWidth: 360)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    AboutTheApp()
}
