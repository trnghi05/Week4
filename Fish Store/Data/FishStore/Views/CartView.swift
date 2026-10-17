//
//  CartView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var store: AppStore
    @State private var showCheckout = false
    var onOrderPlaced: () -> Void = {}

    var body: some View {
        NavigationStack {
            Group {
                if store.cartItems.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: 0) {
                        List {
                            ForEach(store.cartItems) { item in
                                CartRowView(item: item)
                            }
                            .onDelete { store.removeItems(at: $0) }
                        }
                        .listStyle(.plain)

                        summary
                    }
                }
            }
            .navigationTitle("Cart")
            .sheet(isPresented: $showCheckout) {
                CheckoutView(onOrderPlaced: onOrderPlaced)
                    .environmentObject(store)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Your cart is empty")
                .font(.headline)
            Text("Add some products from the Home tab.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    private var summary: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Subtotal")
                Spacer()
                Text(store.cartSubtotal.vnd)
            }
            HStack {
                Text("Shipping")
                Spacer()
                Text(store.shippingFee == 0 ? "Free" : store.shippingFee.vnd)
            }
            Text("Free shipping on orders over \(store.freeShippingThreshold.vnd)")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            HStack {
                Text("Total").font(.headline)
                Spacer()
                Text(store.cartTotal.vnd)
                    .font(.headline)
                    .foregroundColor(.red)
            }

            Button {
                showCheckout = true
            } label: {
                Text("Checkout")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct CartRowView: View {
    @EnvironmentObject var store: AppStore
    let item: CartItem

    var body: some View {
        HStack(spacing: 12) {
            ProductImageView(product: item.product, iconPadding: 10)
                .frame(width: 50, height: 50)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.subheadline)
                Text(item.product.price.vnd)
                    .font(.footnote)
                    .foregroundColor(.red)
            }

            Spacer()

            HStack(spacing: 10) {
                Button {
                    store.changeQuantity(of: item, by: -1)
                } label: {
                    Image(systemName: "minus.circle")
                }

                Text("\(item.quantity)")
                    .frame(minWidth: 20)

                Button {
                    store.changeQuantity(of: item, by: 1)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .buttonStyle(.borderless)
            .font(.title3)
        }
    }
}

#Preview {
    CartView()
        .environmentObject(AppStore())
}
