import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            Selecionadora()
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
