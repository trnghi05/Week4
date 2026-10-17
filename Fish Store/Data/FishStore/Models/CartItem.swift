//
//  CartItem.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import Foundation

struct CartItem: Identifiable, Codable {
    var id = UUID()
    var product: Product
    var quantity: Int

    var total: Double {
        product.price * Double(quantity)
    }
}
