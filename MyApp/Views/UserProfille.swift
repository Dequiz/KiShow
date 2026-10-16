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
    @Query var event: [EventEntity]
    @State var upSheet: Bool = false
    @State var viewModel = EventEntityViewModel()
    
    private var user: UserEntity? {users.first}
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 18) {
                        HStack(spacing: 15) {
                            
                            ProfileIcon(user: user, size: 94)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                HStack {
                                    Text(user?.nameUser ?? "Seu Perfil")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                }
                                
                                Title(titleNames: TitlesNames())
                            }
                            
                            Spacer()
                            
                            Button {
                                upSheet.toggle()
                            } label: {
                                Image(systemName: "pencil.line")
                                    .font(.title3)
                                    .foregroundStyle(Color.primary)
                                    .padding(10)
                                    .glassEffect()
                                    .shadow(radius: 1)
                            }
                            .sheet(isPresented: $upSheet) {
                               EditPerfil()
                            }
                        
                        }
                        
                        .padding(.bottom, 24)

                        VStack(spacing: 28) {
                            VStack(alignment: .leading, spacing: 18) {
                                Text("Frequência de Shows")
                                    .font(.title)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.65)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                if event.count > 0{
                                    LineChart()
                                }else{
                                    Text("Você ainda não possui shows adicionados")
                                        .padding()
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 305)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 35))
                            .padding(.horizontal, 4)
                            VStack(spacing: 8) {
                                Text("Artistas mais ouvidos")
                                    .font(.title3)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.65)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 16)
                                if event.count > 0 {
                                    FavoriteArtists()
                                } else {
                                    Text("Você ainda não possui shows adicionados")
                                        .padding()
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.bottom, 12)
                            .frame(maxWidth: .infinity)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 35))

                            VStack(spacing: 4) {
                                Text("Gêneros mais ouvidos")
                                    .font(.title3)
                                    .lineLimit(1)
                                    .padding()
                                    .minimumScaleFactor(0.65)
                                    .frame(maxWidth: .infinity)
                                if event.count > 0 {
                                    Charts()
                                } else {
                                    Text("Você ainda não possui shows adicionados")
                                        .padding()
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 35))
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
                        .accessibilityLabel("Configurações")
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
