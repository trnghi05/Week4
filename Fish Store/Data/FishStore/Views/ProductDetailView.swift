//
//  ProductDetailView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var store: AppStore
    let product: Product

    @State private var quantity = 1
    @State private var justAdded = false

    private var remaining: Int {
        product.stock - store.quantityInCart(of: product)
    }

    private var related: [Product] {
        store.products.filter {
            $0.categoryId == product.categoryId && $0.id != product.id
        }
    }

    private var stockText: String {
        if product.stock <= 0 { return "Out of stock" }
        if product.stock < 10 { return "Only \(product.stock) left" }
        return "In stock"
    }

    private var stockColor: Color {
        if product.stock <= 0 { return .red }
        if product.stock < 10 { return .orange }
        return .green
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ProductImageView(product: product, iconPadding: 50)
                    .frame(height: 260)
                    .cornerRadius(16)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text(product.name)
                        .font(.title2).bold()

                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", product.rating))
                        Text("•").foregroundColor(.gray)
                        Text(stockText).foregroundColor(stockColor)
                    }
                    .font(.subheadline)

                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(product.price.vnd)
                            .font(.title3).bold()
                            .foregroundColor(.red)
                        if let old = product.oldPrice {
                            Text(old.vnd)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .strikethrough()
                        }
                        if let percent = product.discountPercent {
                            Text("-\(percent)%")
                                .font(.caption).bold()
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }

                    Divider()

                    Text("Description").font(.headline)
                    Text(product.description).foregroundColor(.secondary)

                    if !product.careTip.isEmpty {
                        Text("Care guide").font(.headline)
                        Text(product.careTip).foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                if !related.isEmpty {
                    ProductSectionView(title: "You may also like", products: related)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) { bottomBar }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.toggleFavorite(product)
                } label: {
                    Image(systemName: store.isFavorite(product) ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 16) {
            HStack(spacing: 14) {
                Button {
                    if quantity > 1 { quantity -= 1 }
                } label: {
                    Image(systemName: "minus.circle")
                }
                Text("\(quantity)")
                    .frame(minWidth: 24)
                Button {
                    if quantity < remaining { quantity += 1 }
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .font(.title2)
            .disabled(remaining <= 0)

            Button {
                store.addToCart(product, quantity: quantity)
                quantity = 1
                justAdded = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    justAdded = false
                }
            } label: {
                Text(buttonTitle)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(remaining <= 0 ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(remaining <= 0)
        }
        .padding()
        .background(.bar)
    }

    private var buttonTitle: String {
        if justAdded { return "Added to cart" }
        if remaining <= 0 { return product.stock <= 0 ? "Out of stock" : "Max quantity in cart" }
        return "Add to Cart"
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: .sample)
            .environmentObject(AppStore())
    }
}
