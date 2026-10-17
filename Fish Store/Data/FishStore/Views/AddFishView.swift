//
//  AddFishView.swift
//  FishStore
//
//  Created by MAY 04 on 15/10/26.
//

import SwiftUI

struct AddFishView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var categoryId = ""
    @State private var priceText = ""
    @State private var stockText = ""
    @State private var fishDescription = ""
    @State private var showSaved = false

    private var price: Double? { Double(priceText) }
    private var stock: Int? { Int(stockText) }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
        && (price ?? 0) > 0
        && (stock ?? -1) >= 0
        && !categoryId.isEmpty
    }

    var body: some View {
        Form {
            Section("Fish information") {
                TextField("Name", text: $name)

                Picker("Category", selection: $categoryId) {
                    ForEach(store.categories) { category in
                        Text(category.name).tag(category.id)
                    }
                }

                TextField("Price (VND)", text: $priceText)
                    .keyboardType(.numberPad)
                TextField("Stock", text: $stockText)
                    .keyboardType(.numberPad)
                TextField("Description", text: $fishDescription, axis: .vertical)
            }

            Section {
                Button("Save to fish.txt") {
                    store.addFish(name: name,
                                  categoryId: categoryId,
                                  price: price ?? 0,
                                  stock: stock ?? 0,
                                  description: fishDescription)
                    showSaved = true
                }
                .disabled(!canSave)
            } footer: {
                Text("The new fish is added as a new line at the end of fish.txt and appears in the app right away.")
            }
        }
        .navigationTitle("Add New Fish")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if categoryId.isEmpty {
                categoryId = store.categories.first?.id ?? ""
            }
        }
        .alert("Saved", isPresented: $showSaved) {
            Button("OK") { dismiss() }
        } message: {
            Text("The new fish was added to fish.txt.")
        }
    }
}

// Shows the raw text of a data file, so you can see what was really saved
struct DataFileView: View {
    let fileName: String

    var body: some View {
        ScrollView {
            Text(DataFiles.rawText(fileName))
                .font(.system(.footnote, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .navigationTitle(fileName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AddFishView()
            .environmentObject(AppStore())
    }
}
