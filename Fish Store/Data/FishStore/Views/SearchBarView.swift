//
//  SearchBarView.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search fish, plants, accessories...", text: $text)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}
