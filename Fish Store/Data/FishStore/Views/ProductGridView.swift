//
//  ProductGridView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct ProductGridView: View {
    let products: [Product]

    private let columns = [GridItem(.flexible(), spacing: 12),
                           GridItem(.flexible(), spacing: 12)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(products) { product in
                ProductCardView(product: product, width: nil)
            }
        }
        .padding(.horizontal)
    }
}
