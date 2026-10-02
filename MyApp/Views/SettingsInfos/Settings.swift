//
//  Settings.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI

struct Settings: View {
    var body: some View {
    
            ZStack {
                Form {
                    Section(header: Text("Aplicativo")) {
                        
                        NavigationLink(destination: AboutTheApp()) {
                            Image(systemName: "info")
                            Text("Sobre o Aplicativo")
                        }
                        
                        NavigationLink(destination: Text("Tela: Categorias")) {
                            Image(systemName: "music.note")
                            Text("Categorias Musicais")
                        }
                    }
                    .listRowBackground(Color.details)
                    
                    Section(header: Text("Segurança")) {
                        NavigationLink(destination: ThermsOfService()) {
                            Image(systemName: "text.document.fill")
                            Text("Termos de Uso")
                        }
                        
                        NavigationLink(destination: PrivacyPolicy()) {
                            Image(systemName: "lock.fill")
                            Text("Políticas de Privacidade")
                        }
                    }
                    .listRowBackground(Color.details)
                }
                .background(Color.appBackground)
                .scrollContentBackground(.hidden)
            }
    }
}

#Preview {
    Settings()
}
