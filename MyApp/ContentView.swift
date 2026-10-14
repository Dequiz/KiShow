import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .shows

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: .shows) {
                MyShows()
            } label: {
                tabLabel("Shows", systemImage: "ticket.fill", tab: .shows)
                    .foregroundStyle(Color.mainPink)
            }

            Tab(value: .search) {
                SearchShows()
            } label: {
                tabLabel("Buscar", systemImage: "magnifyingglass.circle.fill", tab: .search)
                    .foregroundStyle(Color.mainPink)

            }

            Tab(value: .profile) {
                UserProfille()
            } label: {
                tabLabel("Perfil", systemImage: "person.crop.circle.fill", tab: .profile)
                    .foregroundStyle(Color.mainPink)

            }
        }
        .navigationBarBackButtonHidden()
    }

    private func tabLabel(_ title: String, systemImage: String, tab: AppTab) -> some View {
        Label(title, systemImage: systemImage)
            .foregroundStyle(selectedTab == tab ? Color.mainPink : Color.secondary)
    }
}

private enum AppTab: Hashable {
    case shows
    case search
    case profile
}

#Preview {
    ContentView()
}


