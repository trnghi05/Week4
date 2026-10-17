//
//  PaymentQRView.swift
//  FishStore
//
//  Created by MAY 04 on 10/10/26.
//

import SwiftUI

struct PaymentQRView: View {
    @EnvironmentObject var store: AppStore
    let amount: Double
    var reference: String? = nil

    @State private var copied = false

    var body: some View {
        VStack(spacing: 12) {
            if UIImage(named: "payment-qr") != nil {
                Image("payment-qr")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .cornerRadius(12)
            } else {
                Text("Add an image named \"payment-qr\" to Assets")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            VStack(spacing: 2) {
                Text(store.bankName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(store.accountName)
                    .font(.headline)
                Text(store.accountNumber)
                    .font(.title3).bold()
            }

            Button {
                UIPasteboard.general.string = store.accountNumber
                copied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    copied = false
                }
            } label: {
                Label(copied ? "Copied" : "Copy account number",
                      systemImage: copied ? "checkmark" : "doc.on.doc")
            }
            .buttonStyle(.bordered)

            Divider()

            LabeledContent("Amount", value: amount.vnd)
                .bold()
            if let reference {
                LabeledContent("Transfer note", value: reference)
            }

            Text("Please enter the exact amount and the transfer note so we can match your payment.")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    PaymentQRView(amount: 355_000, reference: "FISH1A2B3C")
        .environmentObject(AppStore())
        .padding()
}
