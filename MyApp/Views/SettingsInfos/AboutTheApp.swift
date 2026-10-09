//
//  AboutTheApp.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI
import SwiftData

struct AboutTheApp: View {
    @State var dm = TitleDefinitionMachine()
    @State var countButtonClick = 0
    @Environment(\.modelContext) var context
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
                        
                        
                        Text("**Versão:** 1.0.0")
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
            dm.processAction(.secretButtonClicked(clickButton: countButtonClick), context: context)
                }
    }
}

#Preview {
    AboutTheApp()
}
