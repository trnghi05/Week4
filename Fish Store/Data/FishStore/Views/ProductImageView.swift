//
//  ProductImageView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct ProductImageView: View {
    let product: Product
    var iconPadding: CGFloat = 14

    var body: some View {
        Color.blue.opacity(0.1)
            .overlay {
                if UIImage(named: product.id) != nil {
                    Image(product.id)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: product.imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .padding(iconPadding)
                }
            }
            .clipped()
    }
}

#Preview {
    ProductImageView(product: .sample)
        .frame(width: 150, height: 100)
}
