//
//  OrderStatus.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

enum OrderStatus: String, CaseIterable, Codable {
    case pending = "Pending"
    case preparing = "Preparing"
    case shipping = "Shipping"
    case delivered = "Delivered"
    case cancelled = "Cancelled"

    var color: Color {
        switch self {
        case .pending: return .orange
        case .preparing: return .purple
        case .shipping: return .blue
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}
