//
//  HomeView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppStore
    @State private var searchText = ""
    var onCartTap: () -> Void = {}

    private var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var searchResults: [Product] {
        store.products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var onSale: [Product] {
        store.products.filter { $0.oldPrice != nil }
    }

    private var topRated: [Product] {
        Array(store.products.sorted { $0.rating > $1.rating }.prefix(6))
    }

    private let offersDestination = ProductListDestination(title: "Special Offers",
                                                           onSaleOnly: true)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HomeHeaderView(storeName: store.storeName,
                                   subtitle: "The aquatic world at your fingertips",
                                   cartCount: store.cartCount,
                                   onCartTap: onCartTap)
                    LocationRowView(address: $store.deliveryAddress)
                    SearchBarView(text: $searchText)

                    if isSearching {
                        if searchResults.isEmpty {
                            ContentUnavailableView.search(text: searchText)
                        } else {
                            ProductGridView(products: searchResults)
                        }
                    } else {
                        NavigationLink(value: offersDestination) {
                            BannerView()
                        }
                        .buttonStyle(.plain)

                        CategoryRowView(categories: store.categories)

                        ProductSectionView(title: "Special Offers",
                                           products: onSale,
                                           destination: offersDestination)

                        ProductSectionView(title: "Top Rated",
                                           products: topRated,
                                           destination: ProductListDestination(title: "All Products"))
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .navigationDestination(for: ProductListDestination.self) { destination in
                ProductListView(destination: destination)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppStore())
}
