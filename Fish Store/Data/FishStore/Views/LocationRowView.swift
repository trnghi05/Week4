//
//  LocationRowView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct LocationRowView: View {
    @Binding var address: String
    @State private var showEditor = false
    @State private var draft = ""

    var body: some View {
        Button {
            draft = address
            showEditor = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.blue)
                Text("Deliver to:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(address.isEmpty ? "Tap to add your address" : address)
                    .font(.subheadline).bold()
                    .foregroundColor(address.isEmpty ? .blue : .primary)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
        .alert("Delivery address", isPresented: $showEditor) {
            TextField("Enter your address", text: $draft)
            Button("Save") {
                address = draft.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    LocationRowView(address: .constant(""))
}
