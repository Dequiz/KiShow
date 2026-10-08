//
//  Title.swift
//  MyApp
//
//  Created by Andre on 29/09/26.
//
import SwiftUI
import SwiftData
struct Title: View {
    var titleNames: TitlesNames
    @Query var titles: [TitleEntity]
    @Query var events: [EventEntity]
    @Query var experiences: [ExperienceEntity]
    @State private var upSheet = false
    @State private var presentHint = ""
    @State private var presentedTitle = "Escolha Seu Título"

    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    private var unlockedNames: Set<String> {
        Set(titles.map(\.nameTitle))
    }

    private func progress(for definition: TitleDefinition) -> String? {
        guard let goal = definition.goal, let metric = definition.metric else { return nil }
        var current = 0
        switch metric {
        case .shows: current = events.count
        case .photos:
            var temporary = 0
            for i in 0..<experiences.count{
                if let temporary = experiences[i].imageContent?.count{
                    current += temporary
                }
            }
        case .texte:
            var temporary = 0
            for i in 0..<experiences.count{
                if let temporary = experiences[i].textContent?.count{
                    current += temporary
                }
            }
        case .characters:
            for experience in experiences {
                if let texts = experience.textContent {
                    for text in texts {
                        current += text.count
                    }
                }
            }
        }
        return "\(min(current, goal))/\(goal)"
    }

    var body: some View {
        Button {
            upSheet.toggle()
        } label: {
            Text(presentedTitle)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .glassEffect()
                .shadow(radius: 1)
        }
        .sheet(isPresented: $upSheet) {
            ZStack {
                Color("SheetBackground").ignoresSafeArea()

                NavigationStack {
                    ScrollView {
                        if !presentHint.isEmpty{
                            VStack{
                                Text("Dica: \(presentHint)")
                                    .padding()
                                    .background(Color.mainPurple)
                                    .clipShape(.capsule)
                            }
                        }
                       
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(titleNames.titles) { definition in
                                let isUnlocked = unlockedNames.contains(definition.name)
                                Button {
                                    if !isUnlocked{
                                        presentHint = definition.hint
                                    }else{
                                        presentedTitle = definition.name
                                        upSheet = false
                                    }
                                
                                } label: {
                                    VStack(spacing: 2) {
                                        Text(definition.name)
                                            .font(.body)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                        if !isUnlocked {
                                                                                   Text(progress(for: definition) ?? definition.hint)
                                                                                       .font(.caption2)
                                                                                       .lineLimit(1)
                                                                                       .minimumScaleFactor(0.5)
                                                                               }
                                    }
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .padding(.horizontal, 8)
                                    .background(isUnlocked ? Color.mainPurple : Color.mainPurple.opacity(0.4))
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
