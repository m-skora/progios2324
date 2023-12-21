//
//  ProductsView.swift
//  zad3cored
//
//  Created by mikolaj on 21/12/2023.
//

import SwiftUI
import CoreData

struct ProductsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationView {
            List {
                ForEach(products) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        VStack(alignment: .leading) {
                            if let productName = product.name {
                                Text("\(productName)")
                                    .font(.headline)
                            } else {
                                Text("Product name missing")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            Text("Price: \(product.price, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .onAppear {
                DataInitializer.preloadData(viewContext: viewContext)
            }
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
