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
                        
                        .padding(.bottom, 24)

                        VStack(spacing: 28) {
                            VStack(alignment: .leading){
                                Text("Frequência de Shows")
                                    .font(.system(size: 20, weight: .semibold))
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
                            GeometryReader { geometry in
                                let spacing: CGFloat = 12
                                let cardWidth = (geometry.size.width - spacing) / 2
                                let titleSize = min(16, max(12, cardWidth * 0.085))

                                HStack(alignment: .top, spacing: spacing) {
                                    VStack(spacing: 4) {
                                        Text("Artistas mais ouvidos")
                                            .font(.system(size: titleSize, weight: .semibold))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.65)
                                            .frame(maxWidth: .infinity)
                                            .offset(y:15)
                                        Spacer()
                                        if event.count > 0 {
                                            FavoriteArtists()
                                        } else {
                                            Text("Você ainda não possui shows adicionados")
                                                .padding()
                                                .foregroundStyle(.secondary)

                                        }
                                        Spacer()

                                    }
                                    .padding(.horizontal, 12)
                                    .frame(width: cardWidth, height: 205)
                                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 35))

                                    VStack(spacing: 4) {
                                        Text("Gêneros mais ouvidos")
                                            .font(.system(size: titleSize, weight: .semibold))
                                            .lineLimit(1)
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
                                    .frame(width: cardWidth, height: 205)
                                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 35))
                                }
                            }
                            .frame(height: 205)
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
