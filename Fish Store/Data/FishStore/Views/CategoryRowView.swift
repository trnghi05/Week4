//
//  CategoryRowView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct CategoryRowView: View {
    let categories: [ProductCategory]

    private let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(categories) { cat in
                NavigationLink(value: ProductListDestination(title: cat.name,
                                                             categoryId: cat.id)) {
                    VStack(spacing: 6) {
                        categoryIcon(for: cat)

                        Text(cat.name)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .frame(height: 32, alignment: .top)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func categoryIcon(for cat: ProductCategory) -> some View {
        if UIImage(named: "cat-\(cat.id)") != nil {
            // Photo fills the whole tile, no blue border
            Image("cat-\(cat.id)")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        } else {
            // No photo yet: fall back to the system icon on a light blue tile
            Image(systemName: cat.iconName)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 64, height: 64)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
    NavigationStack {
        CategoryRowView(categories: [
            ProductCategory(id: "fish", name: "Fish", iconName: "drop.fill"),
            ProductCategory(id: "plants", name: "Aquatic Plants", iconName: "leaf.fill")
        ])
    }
}
