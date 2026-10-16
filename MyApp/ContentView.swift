import SwiftUI
import UIKit

struct ContentView: View {
    @State private var ticketMasterShow = TicketMasterShowViewModel()

    var body: some View {
        TabView{
            Tab("Shows", systemImage: "ticket.fill") {
                MyShows()
                    .tint(Color(uiColor: .systemBlue))
            }
            Tab("Buscar", systemImage: "magnifyingglass.circle.fill") {
                SearchShows(ticketMasterShow: ticketMasterShow)
                    .tint(Color(uiColor: .systemBlue))
            }
            Tab("Perfil", systemImage: "person.crop.circle.fill") {
                UserProfille()
                    .tint(Color(uiColor: .systemBlue))
            }
        }
        .tint(Color.mainPink)
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    ContentView()
}
