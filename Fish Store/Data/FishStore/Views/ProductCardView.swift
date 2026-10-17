//
//  ProductCardView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct ProductCardView: View {
    @EnvironmentObject var store: AppStore
    let product: Product
    var width: CGFloat? = 150     // nil = fill the column (used in grids)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            NavigationLink(value: product) {
                VStack(alignment: .leading, spacing: 6) {
                    ProductImageView(product: product)
                        .frame(height: 100)
                        .cornerRadius(10)
                        .overlay(alignment: .topLeading) { discountBadge }

                    Text(product.name)
                        .font(.subheadline)
                        .lineLimit(1)

                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", product.rating))
                            .foregroundColor(.gray)
                    }
                    .font(.caption2)
                }
            }
            .buttonStyle(.plain)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    if product.stock <= 0 {
                        Text("Sold out")
                            .font(.footnote).bold()
                            .foregroundColor(.gray)
                    } else {
                        Text(product.price.vnd)
                            .font(.footnote).bold()
                            .foregroundColor(.red)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    Text((product.oldPrice ?? product.price).vnd)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .strikethrough()
                        .opacity(product.oldPrice == nil ? 0 : 1)
                }
                Spacer()
                Button {
                    store.addToCart(product)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
                .disabled(product.stock <= 0)
            }
        }
        .padding(10)
        .frame(width: width)
        .frame(maxWidth: width == nil ? .infinity : nil)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .overlay(alignment: .topTrailing) { heartButton }
    }

    @ViewBuilder
    private var discountBadge: some View {
        if let percent = product.discountPercent {
            Text("-\(percent)%")
                .font(.caption2).bold()
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(6)
                .padding(6)
        }
    }

    private var heartButton: some View {
        Button {
            store.toggleFavorite(product)
        } label: {
            Image(systemName: store.isFavorite(product) ? "heart.fill" : "heart")
                .font(.subheadline)
                .foregroundColor(.red)
                .padding(6)
                .background(Color.white.opacity(0.9))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(14)
    }
}

#Preview {
    NavigationStack {
        ProductCardView(product: .sample)
            .environmentObject(AppStore())
    }
}
