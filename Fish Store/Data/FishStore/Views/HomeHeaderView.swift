//
//  HomeHeaderView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct HomeHeaderView: View {
    var storeName: String
    var subtitle: String
    var cartCount: Int = 0
    var onCartTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Color.blue
                if UIImage(named: "logo") != nil {
                    Image("logo")
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "drop.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(storeName)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            iconButton(systemName: "bell", badge: 0, action: {})
            iconButton(systemName: "cart", badge: cartCount, action: onCartTap)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private func iconButton(systemName: String, badge: Int, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(alignment: .topTrailing) {
                    if badge > 0 {
                        Text("\(badge)")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 4, y: -4)
                    }
                }
        }
    }
}

#Preview {
    HomeHeaderView(storeName: "Ornamental Fish 🐟 🐠 🐡",
                   subtitle: "The aquatic world at your fingertips",
                   cartCount: 2)
}
