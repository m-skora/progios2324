//
//  ProductDetailView.swift
//  zad3cored
//
//  Created by mikolaj on 21/12/2023.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product

    var body: some View {
        VStack {
            Text(product.name ?? "Unknown Product")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding()

            if let category = product.category {
                Text("Category: \(category.name ?? "Unknown Category")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            }

            Text("Price: \(product.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()

            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}
