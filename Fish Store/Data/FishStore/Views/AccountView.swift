//
//  AccountView.swift
//  FishStore
//
//  Created by MAY 04 on 15/10/26.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var store: AppStore
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("My profile") {
                    TextField("Full name", text: $store.customerName)
                    TextField("Phone number", text: $store.customerPhone)
                        .keyboardType(.phonePad)
                    TextField("Delivery address", text: $store.deliveryAddress, axis: .vertical)
                }

                Section("Activity") {
                    LabeledContent("Orders", value: "\(store.orders.count)")
                    LabeledContent("Favorites", value: "\(store.favoriteIDs.count)")
                }

                Section("Our store") {
                    NavigationLink {
                        MapView()
                            .navigationTitle("Store Location")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("Store location", systemImage: "map")
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Address").font(.caption).foregroundColor(.gray)
                        Text(store.storeAddress)
                    }
                    LabeledContent("Hours", value: store.storeHours)
                    LabeledContent("Phone", value: store.storePhone)
                }

                Section("Shop management") {
                    NavigationLink {
                        AddFishView()
                    } label: {
                        Label("Add new fish", systemImage: "plus.circle")
                    }
                    NavigationLink {
                        DataFileView(fileName: DataFiles.fishFile)
                    } label: {
                        Label("View fish.txt", systemImage: "doc.text")
                    }
                    NavigationLink {
                        DataFileView(fileName: DataFiles.categoryFile)
                    } label: {
                        Label("View category.txt", systemImage: "doc.text")
                    }
                    Button("Restore default catalog", role: .destructive) {
                        store.restoreDefaultCatalog()
                    }
                }

                Section {
                    Button("Reset all data", role: .destructive) {
                        showResetAlert = true
                    }
                }
            }
            .navigationTitle("Account")
            .alert("Reset all data?", isPresented: $showResetAlert) {
                Button("Reset", role: .destructive) { store.resetUserData() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This clears your cart, orders, favorites and profile.")
            }
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(AppStore())
}
