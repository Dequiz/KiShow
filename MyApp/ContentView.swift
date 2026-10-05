import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        TabView{
            Tab("Shows",systemImage: "ticket.fill"){
                 MyShows()
            }
            Tab("Buscar",systemImage: "magnifyingglass.circle.fill"){
                
            }
            Tab("Perfil",systemImage: "person.crop.circle.fill"){
                UserProfille()
            }
        }
        .navigationBarBackButtonHidden()
        .tint(.mainPink)
        
    }
}

#Preview {
    ContentView()
}


