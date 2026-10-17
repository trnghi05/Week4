//
//  ProductListView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var store: AppStore
    let destination: ProductListDestination

    var body: some View {
        let items = store.filteredProducts(for: destination)

        ScrollView {
            if items.isEmpty {
                ContentUnavailableView("No products yet",
                                       systemImage: "fish",
                                       description: Text("Please check back soon."))
                    .padding(.top, 60)
            } else {
                ProductGridView(products: items)
                    .padding(.vertical)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(destination.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }
}
