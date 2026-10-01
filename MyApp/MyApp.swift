import SwiftUI
import SwiftData

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
          NameConfirmationView()
        }
        .modelContainer(for: UserEntity.self)
    }
       
}
