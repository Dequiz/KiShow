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
                Color("AppBackground")
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Aplicativo")) {
                        
                        NavigationLink(destination: AboutTheApp()) {
                            Text("Sobre o Aplicativo")
                        }
                        
                        NavigationLink(destination: Text("Tela: Categorias")) {
                            Text("Categorias")
                        }
                    }
                    
                    Section(header: Text("Segurança")) {
                        NavigationLink(destination: ThermsOfService()) {
                            Text("Termos de Uso")
                        }
                        
                        NavigationLink(destination: PrivacyPolicy()) {
                            Text("Políticas de Privacidade")
                        }
                    }
                }
            }
    }
}

#Preview {
    Settings()
}
