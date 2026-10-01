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
                    .foregroundStyle(Color.secondary)
                    .padding(10)
                    .glassEffect()
                    .shadow(radius: 1)
            }
        }
        .sheet(isPresented: $upSheet) {
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
                                    .background(Color.mainPink)
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

#Preview {
    Title(titleNames: TitlesNames())
}
