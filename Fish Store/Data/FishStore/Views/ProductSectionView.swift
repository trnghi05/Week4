//
//  ProductSectionView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct ProductSectionView: View {
    let title: String
    let products: [Product]
    var destination: ProductListDestination? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                if let destination {
                    NavigationLink(value: destination) {
                        Text("See all >")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(products) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
    }
}
