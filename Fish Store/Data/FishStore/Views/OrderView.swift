//
//  OrderView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationStack {
            Group {
                if store.orders.isEmpty {
                    ContentUnavailableView("No orders yet",
                                           systemImage: "list.clipboard",
                                           description: Text("Your orders will appear here."))
                } else {
                    List(store.orders) { order in
                        OrderRowView(order: order)
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}

struct OrderRowView: View {
    @EnvironmentObject var store: AppStore
    let order: Order

    @State private var showQR = false

    private var isFinished: Bool {
        order.status == .delivered || order.status == .cancelled
    }

    private var needsPayment: Bool {
        order.paymentMethod == .bankTransfer && order.status == .pending
    }

    private var transferNote: String {
        "FISH\(order.id.uuidString.prefix(6))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Order #\(order.id.uuidString.prefix(6))")
                    .font(.headline)
                Spacer()
                Text(order.status.rawValue)
                    .font(.caption).bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(order.status.color.opacity(0.15))
                    .foregroundColor(order.status.color)
                    .clipShape(Capsule())
            }

            Text(order.orderDate.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(.gray)

            ForEach(order.items) { item in
                Text("\(item.quantity) x \(item.product.name)")
                    .font(.subheadline)
            }

            Text("\(order.customerName) • \(order.phone)")
                .font(.caption)
                .foregroundColor(.gray)

            Text(order.address)
                .font(.caption)
                .foregroundColor(.gray)

            Text("Payment: \(order.paymentMethod.rawValue)")
                .font(.caption)
                .foregroundColor(.gray)

            if !order.note.isEmpty {
                Text("Note: \(order.note)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            HStack {
                Text("Total: \(order.total.vnd)")
                    .font(.subheadline).bold()
                Spacer()

                if needsPayment {
                    Button("Pay now") { showQR = true }
                }
                if order.status == .pending {
                    Button("Cancel") {
                        store.cancelOrder(order)
                    }
                    .foregroundColor(.red)
                }
                if !isFinished {
                    Button("Next step") {
                        store.advanceStatus(of: order)
                    }
                }
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 6)
        .sheet(isPresented: $showQR) {
            NavigationStack {
                ScrollView {
                    PaymentQRView(amount: order.total,
                                  reference: transferNote)
                        .padding()
                }
                .navigationTitle("Pay by transfer")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { showQR = false }
                    }
                }
            }
            .environmentObject(store)
        }
    }
}

#Preview {
    OrderView()
        .environmentObject(AppStore())
}
