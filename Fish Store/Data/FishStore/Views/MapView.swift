//
//  MapView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var store: AppStore

    // Approximate coordinates of Landmark 81
    private let storeCoordinate = CLLocationCoordinate2D(latitude: 10.7951,
                                                         longitude: 106.7218)

    var body: some View {
        Map(initialPosition: .region(
            MKCoordinateRegion(center: storeCoordinate,
                               span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                      longitudeDelta: 0.01)))) {
            Marker(store.storeName,
                   systemImage: "drop.fill",
                   coordinate: storeCoordinate)
        }
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(store.storeName).font(.headline)
                Text(store.storeAddress)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(.regularMaterial)
            .cornerRadius(10)
            .padding(8)
        }
    }
}

#Preview {
    MapView()
        .environmentObject(AppStore())
}
