import SwiftUI
import SwiftData
import AVKit
import TipKit

@main
struct MyApp: App {
    init() {
        #if DEBUG
        // try? Tips.resetDatastore()
        #endif

        try? Tips.configure([
            .displayFrequency(.immediate)
        ])
    }

    var body: some Scene {
        WindowGroup {
            SplashCoordinator()
        }
        .modelContainer(for: [
            UserEntity.self,
            ExperienceEntity.self,
            EventEntity.self,
            TitleEntity.self,
            ShowEntity.self
        ])
    }
}

struct SplashCoordinator: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView {
                    withAnimation {
                        showSplash = false
                    }
                }
            } else {
                Selecionadora()
            }
        }
    }
}

struct Selecionadora: View {
    @Query(sort: \UserEntity.idUser) private var users: [UserEntity]

    var body: some View {
        if users.isEmpty {
            NameConfirmationView()
        } else {
            ContentView()
        }
    }
}
