//
//  UserProfille.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//
import SwiftUI
import SwiftData

struct UserProfille: View {
    @Query(sort: \UserEntity.idUser) var users: [UserEntity]
    @State var upSheet: Bool = false
    
    private var user: UserEntity? {users.first}
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            
                            ProfileIcon(user: user, size: 90)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(user?.nameUser ?? "Seu Perfil")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Title(titleNames: TitlesNames())
                            }
                            
                            Spacer()
                            
                            Button {
                                upSheet.toggle()
                            } label: {
                                Image(systemName: "pencil.line")
                                    .font(.title2)
                                    .foregroundStyle(Color.primary)
                            }
                            .sheet(isPresented: $upSheet) {
                               EditPerfil()
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
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
                    ToolbarItem {
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
