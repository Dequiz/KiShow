//
//  AppTips.swift
//  MyApp
//
//  Created by Andre on 14/10/26.
//

import SwiftUI
import TipKit

struct CenteredTipViewStyle: TipViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 12) {
            if let image = configuration.image {
                image
                    .font(.title2)
                    .frame(width: 36, height: 36)
            }

            VStack(alignment: .leading, spacing: 4) {
                if let title = configuration.title {
                    title.font(.headline)
                }

                if let message = configuration.message {
                    message
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ForEach(configuration.actions) { action in
                    Button(action: action.handler) {
                        action.label()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .padding(.trailing, 40)
        .overlay(alignment: .topTrailing) {
            Button {
                configuration.tip.invalidate(reason: .tipClosed)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Fechar dica")
            .padding(12)
        }
    }
}

struct CustomizeTicketTip: Tip {
    static let firstShowAdded = Tips.Event(id: "firstShowAdded")

    var title: Text {
        Text("Customizar Ticket")
    }

    var message: Text? {
        Text("Pressione o ticket por alguns segundos e customize sua cor.")
    }

    var image: Image? {
        Image(systemName: "paintpalette")
    }

    var rules: [Rule] {
        #Rule(Self.firstShowAdded) {
            $0.donations.count >= 1
        }
    }

    var options: [TipOption] {
        Tip.MaxDisplayCount(1)
    }
}

struct ProfileTitleTip: Tip {
    var title: Text {
        Text("Escolha seu título")
    }

    var message: Text? {
        Text("Selecione aqui diferentes títulos para o seu perfil. Você pode desbloquea-los conforme usa o app.")
    }

    var image: Image? {
        Image(systemName: "rosette")
    }

    var options: [TipOption] {
        Tip.MaxDisplayCount(1)
    }
}


struct FavoritoTip: Tip {
    var title: Text {
        Text("Adicionar Mídias")
    }

    var message: Text? {
        Text("Toque aqui para adicionar mídias ao seu show.")
    }

    var image: Image? {
        Image(systemName: "plus")
    }

    var options: [TipOption] {
        Tip.MaxDisplayCount(1)
    }
}

struct EventStoryTip: Tip {
    static let firstExperienceAdded = Tips.Event(id: "firstExperienceAddedToEvent")

    var title: Text {
        Text("Conheça o story do show")
    }

    var message: Text? {
        Text("Fotos e vídeos deste show ficam reunidos aqui, toque no disco para rever suas lembranças.")
    }

    var image: Image? {
        Image(systemName: "play.rectangle")
    }

    var rules: [Rule] {
        #Rule(Self.firstExperienceAdded) {
            $0.donations.count >= 1
        }
    }

    var options: [TipOption] {
        Tip.MaxDisplayCount(1)
    }
}


struct InsertMidiaTip: Tip {
    var title: Text {
        Text("Inserir mídias")
    }

    var message: Text? {
        Text("Por meio deste seletor você escolhe qual mídia inserir (Fotos, Vídeos, Áudios e Textos).")
    }
}

struct AnimatedMidiasIcon: View {
    private let symbols = [
        "video.circle.fill",
        "photo.circle.fill",
        "text.justify.right",
        "waveform.circle.fill"
    ]

    @State private var index = 0

    var body: some View {
        Image(systemName: symbols[index])
            .font(.largeTitle)
            .contentTransition(.symbolEffect(.replace))
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(1.5))
                    withAnimation {
                        index = (index + 1) % symbols.count
                    }
                }
            }
    }
}

struct MidiasTipStyle: TipViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .top, spacing: 12) {
            AnimatedMidiasIcon()

            VStack(alignment: .leading, spacing: 4) {
                configuration.title
                    .font(.headline)
                configuration.message?
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Button {
                configuration.tip.invalidate(reason: .tipClosed)
            } label: {
                Image(systemName: "xmark")
                    .font(.footnote.bold())
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}
