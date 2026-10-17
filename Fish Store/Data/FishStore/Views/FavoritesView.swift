//
//  FavoritesView.swift
//  FishStore
//
//  Created by MAY 04 on 15/10/26.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationStack {
            Group {
                if store.favoriteProducts.isEmpty {
                    ContentUnavailableView("No favorites yet",
                                           systemImage: "heart",
                                           description: Text("Tap the heart on a product to save it here."))
                } else {
                    ScrollView {
                        ProductGridView(products: store.favoriteProducts)
                            .padding(.vertical)
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AppStore())
}
