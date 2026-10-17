//
//  BannerView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct BannerView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(colors: [.blue, .cyan],
                           startPoint: .leading,
                           endPoint: .trailing)

            VStack(alignment: .leading, spacing: 6) {
                Text("THIS MONTH'S OFFER")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .clipShape(Capsule())

                Text("Healthy Fish, Beautiful Tank")
                    .font(.title3).bold()
                    .foregroundColor(.white)

                Text("A relaxing space for every home")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(height: 140)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    BannerView()
}
