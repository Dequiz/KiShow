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
            
            VStack {
                Form {
                    Section(header: Text("Aplicativo")) {
                        HStack{
                            Text("Sobre o Aplicativo")
                        }
                        HStack{
                            Text("Categorias")
                        }
                        
                    }
                    Section(header: Text("Segurança")) {
                        HStack {
                            Text("Termos de Uso")
                        }
                        HStack {
                            Text("Políticas de Privacidade")
                        }
                        
                    }
                }
            }
            .navigationTitle("Ajustes")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

#Preview {
    Settings()
}
