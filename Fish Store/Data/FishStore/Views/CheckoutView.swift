//
//  CheckoutView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var customerName = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var payment: PaymentMethod = .cashOnDelivery
    @State private var note = ""
    var onOrderPlaced: () -> Void = {}

    private func isFilled(_ text: String) -> Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var canOrder: Bool {
        isFilled(customerName) && isFilled(phone) && isFilled(address)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact") {
                    TextField("Full name", text: $customerName)
                    TextField("Phone number", text: $phone)
                        .keyboardType(.phonePad)
                }

                Section("Delivery address") {
                    TextField("Enter your delivery address", text: $address, axis: .vertical)
                }

                Section("Payment method") {
                    Picker("Payment method", selection: $payment) {
                        ForEach(PaymentMethod.allCases) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()

                    if payment == .bankTransfer {
                        Section("Scan to pay") {
                            PaymentQRView(amount: store.cartTotal)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }

                Section("Note for the shop") {
                    TextField("Optional", text: $note, axis: .vertical)
                }

                Section("Order summary") {
                    LabeledContent("Items", value: "\(store.cartCount)")
                    LabeledContent("Subtotal", value: store.cartSubtotal.vnd)
                    LabeledContent("Shipping",
                                   value: store.shippingFee == 0 ? "Free" : store.shippingFee.vnd)
                    LabeledContent("Total", value: store.cartTotal.vnd)
                        .bold()
                }

                Section {
                    Button("Place Order") {
                        store.customerName = customerName
                        store.customerPhone = phone
                        store.deliveryAddress = address
                        store.placeOrder(customerName: customerName,
                                         phone: phone,
                                         address: address,
                                         payment: payment,
                                         note: note)
                        dismiss()
                        onOrderPlaced()
                    }
                    .disabled(!canOrder)
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                customerName = store.customerName
                phone = store.customerPhone
                address = store.deliveryAddress
            }
        }
    }
}

#Preview {
    CheckoutView()
        .environmentObject(AppStore())
}
