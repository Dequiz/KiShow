//
//  Title.swift
//  MyApp
//
//  Created by Andre on 29/09/26.
//
import SwiftUI

struct Title: View {
    var titleNames: TitlesNames
    @State private var upSheet = false
    @State private var presentedTitle = "Escolha Seu Título"
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        Button {
            upSheet.toggle()
        } label: {
            HStack {
                Text(presentedTitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .glassEffect()
                    .shadow(radius: 1)
            }
        }
        .sheet(isPresented: $upSheet) {
            ZStack {
                Color("SheetBackground")
                    .ignoresSafeArea()
        
                NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(titleNames.titleNames, id: \.self) { titulo in
                                Button {
                                    presentedTitle = titulo
                                    upSheet = false
                                } label: {
                                    Text(titulo)
                                        .font(.body)
                                        .lineLimit(1)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                        .background(Color.mainPurple)
                                        .clipShape(.capsule)
                                        .foregroundStyle(Color.white)
                                }
                            }
                        }
                        .padding(20)
                    }
                    .navigationTitle("Escolha seu Título")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    Title(titleNames: TitlesNames())
}
