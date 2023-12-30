//
//  ContentView.swift
//  zad4servdata
//
//  Created by mikolaj on 30/12/2023.
//

import SwiftUI

struct Product: Codable {
    let id: Int
    let name: String
    let category_id: Int
}

struct Category: Codable {
    let id: Int
    let name: String
}

struct ProductWithCategory: Identifiable {
    let id: Int
    let product: Product
    let categoryName: String
}

struct ContentView: View {
    @State private var productWithCategories: [ProductWithCategory] = []

    var body: some View {
        VStack {
            Text("fetched data")
            List(productWithCategories) { productWithCategory in
                VStack(alignment: .leading) {
                    Text("name: \(productWithCategory.product.name)")
                    Text("category: \(productWithCategory.categoryName)")
                }
            }
        }
        .onAppear {
            fetchProductsWithCategories { productsWithCategories in
                if let productsWithCategories = productsWithCategories {
                    self.productWithCategories = productsWithCategories
                } else {
                    print("failed to fetch")
                }
            }
        }
    }

    func fetchProductsWithCategories(completion: @escaping ([ProductWithCategory]?) -> Void) {
        let productsURL = URL(string: "http://127.0.0.1:5000/api/products")!
        let categoriesURL = URL(string: "http://127.0.0.1:5000/api/categories")!

        let productsTask = URLSession.shared.dataTask(with: productsURL) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let products = try JSONDecoder().decode([Product].self, from: data)

                let categoriesTask = URLSession.shared.dataTask(with: categoriesURL) { data, response, error in
                    guard let data = data, error == nil else {
                        completion(nil)
                        return
                    }

                    do {
                        let categories = try JSONDecoder().decode([Category].self, from: data)

                        let productsWithCategories = products.map { product in
                            let categoryName = categories.first(where: { $0.id == product.category_id })?.name ?? "unknown"
                            return ProductWithCategory(id: product.id, product: product, categoryName: categoryName)
                        }

                        completion(productsWithCategories)
                    } catch {
                        print("error decoding categories")
                        completion(nil)
                    }
                }

                categoriesTask.resume()

            } catch {
                print("error decoding products")
                completion(nil)
            }
        }

        productsTask.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
