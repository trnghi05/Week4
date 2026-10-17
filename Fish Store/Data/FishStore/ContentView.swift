import SwiftUI

struct ContentView: View {
    @StateObject private var store = AppStore()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(onCartTap: { selectedTab = 2 })
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "heart.fill") }
                .tag(1)

            CartView(onOrderPlaced: { selectedTab = 3 })
                .tabItem { Label("Cart", systemImage: "cart.fill") }
                .badge(store.cartCount)
                .tag(2)

            OrderView()
                .tabItem { Label("Orders", systemImage: "list.clipboard.fill") }
                .tag(3)

            AccountView()
                .tabItem { Label("Account", systemImage: "person.fill") }
                .tag(4)
        }
        .environmentObject(store)
    }
}

#Preview {
    ContentView()
}
