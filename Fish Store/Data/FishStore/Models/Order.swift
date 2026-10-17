//
//  Order.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import Foundation

enum PaymentMethod: String, Codable, CaseIterable, Identifiable {
    case cashOnDelivery = "Cash on delivery"
    case bankTransfer = "Bank transfer"

    var id: String { rawValue }
}

struct Order: Identifiable, Codable {
    var id = UUID()
    var customerName: String
    var phone: String
    var address: String
    var items: [CartItem]
    var orderDate: Date
    var status: OrderStatus
    var shippingFee: Double
    var paymentMethod: PaymentMethod
    var note: String

    var subtotal: Double {
        items.reduce(0) { $0 + $1.total }
    }

    var total: Double {
        subtotal + shippingFee
    }
}
