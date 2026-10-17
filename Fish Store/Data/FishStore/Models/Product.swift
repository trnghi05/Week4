//
//  Product.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: String               // fixed id, also used as the photo name in Assets
    var name: String
    var categoryId: String
    var description: String
    var price: Double
    var oldPrice: Double? = nil  // set it to show a discount
    var imageName: String        // fallback SF Symbol when there is no photo
    var stock: Int
    var rating: Double = 4.5
    var careTip: String = ""

    var discountPercent: Int? {
        guard let oldPrice, oldPrice > price else { return nil }
        return Int(((oldPrice - price) / oldPrice * 100).rounded())
    }
}

// Used to open a list of products (a category, special offers, all products)
struct ProductListDestination: Hashable {
    var title: String
    var categoryId: String? = nil
    var onSaleOnly = false
}

extension Product {
    static let sample = Product(id: "betta-halfmoon",
                                name: "Halfmoon Betta",
                                categoryId: "fish",
                                description: "A showy betta with a wide, half-moon tail.",
                                price: 85_000,
                                oldPrice: 120_000,
                                imageName: "drop.fill",
                                stock: 30,
                                rating: 4.8,
                                careTip: "Water 24-28°C. Feed small portions twice a day.")
}
