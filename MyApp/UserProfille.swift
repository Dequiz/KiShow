//
//  UserProfille.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//
import SwiftUI

struct UserProfille: View {
    var hasImage: Bool = false
    
    var body: some View {
        NavigationStack {
                ZStack() {
                    Color("AppBackground")
                        .ignoresSafeArea()
                    
                    ScrollView {
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            
                            if (hasImage) {
                            Image("Teste")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 90, height: 90)
                            } else {
                                
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 90, height: 90)
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Nome Perfil")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Title(titleNames: TitlesNames())
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)
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
