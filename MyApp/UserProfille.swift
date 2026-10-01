//
//  UserProfille.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//
import SwiftUI

struct UserProfille: View {
    var hasImage: Bool = false
    var imagemUsuario: String = "Teste"
    
    var body: some View {
        NavigationStack {
                ZStack() {
                    Color("AppBackground")
                        .ignoresSafeArea()
                    
                    ScrollView {
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            
                            if (hasImage) {
                            Image(imagemUsuario)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 90, height: 90)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(Color.profileIcon)
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Nome Perfil")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Title(titleNames: TitlesNames())
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "pencil.line")
                                    .font(.title2)
                                    .foregroundStyle(Color.primary)
                            }
                            
                        }
                        
                        Spacer()
                        
                        VStack (){
                            
                            RoundedRectangle(cornerRadius: 25)
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                
                                
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                
                                
                            }
                        }
                    }
                    .padding(20)
                }
                .toolbar {
                    ToolbarItem() {
                        NavigationLink(destination: Settings()) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.primary)
                        }
                    }
                    
                }
                .navigationTitle("Perfil")
                .toolbarTitleDisplayMode(.inlineLarge)
                
            }
        }
    }
}

#Preview {
    UserProfille()
}
