import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        
        TabView{
            Tab("Shows",systemImage: "ticket.fill"){
                 MyShows()
            }
            Tab("Buscar",systemImage: "magnifyingglass.circle.fill"){
                SearchShows()
            }
            Tab("Perfil",systemImage: "person.crop.circle.fill"){
                UserProfille()
            }
        }
        .tint(.mainPink)
        
    }
}

#Preview {
    ContentView()
}


