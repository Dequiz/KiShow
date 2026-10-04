import SwiftUI
import SwiftData

@main struct MyApp: App {
    @Query(sort: \UserEntity.idUser) var users: [UserEntity]
   
    var body: some Scene {
        @State var usuarioLogado = users.first?.nameUser

        WindowGroup {

                NameConfirmationView()
            }
        .modelContainer(for: UserEntity.self)
        .modelContainer(for: ExperienceEntity.self)
            }
        }
    
