//
//  CheckoutView.swift
//  zad6
//
//  Created by mikolaj on 30/01/2024.
//

import SwiftUI

struct CheckoutView: View {
    @Binding var shoppingCart: [ProductWithCategory]
    @State private var totalPrice: Double = 0
    @State private var showPaymentSheet: Bool = false

    var body: some View {
        VStack {
            List(shoppingCart) { productWithCategory in
                VStack(alignment: .leading) {
                    Text("Nazwa: \(productWithCategory.product.name)")
                    Text("Kategoria: \(productWithCategory.categoryName)")
                    Text("Cena: \(String(format: "%.2f", productWithCategory.product.price)) zł")
                }
            }

            Text("Suma: \(String(format: "%.2f", shoppingCart.reduce(0) { $0 + $1.product.price })) zł")

            NavigationLink(destination: PaymentView(shoppingCart: shoppingCart), isActive: $showPaymentSheet) {
                                EmptyView()
            }
            .hidden()

            Button(action: {
                showPaymentSheet.toggle()
            }) {
                Text("Złóż zamówienie")
            }
        }
        .navigationBarTitle("Koszyk")
    }
}
