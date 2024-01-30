//
//  ContentView.swift
//  zad4servdata
//
//  Created by mikolaj on 30/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var productWithCategories: [ProductWithCategory] = []
    @State private var shoppingCart: [ProductWithCategory] = []

    var body: some View {
        NavigationView {
            VStack {
                List(productWithCategories) { productWithCategory in
                    VStack(alignment: .leading) {
                        Text("Nazwa: \(productWithCategory.product.name)")
                        Text("Kategoria: \(productWithCategory.categoryName)")
                        Text("Cena: \(String(format: "%.2f", productWithCategory.product.price)) zł")
                        Button(action: {
                            addToCart(productWithCategory)
                        }) {
                            Text("Do koszyka")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }

                NavigationLink(destination: CheckoutView(shoppingCart: $shoppingCart)) {
                    Text("Przejdź do koszyka")
                }
            }
            .navigationBarTitle("Sklep")
        }
        .onAppear {
            fetchProductsWithCategories { productsWithCategories in
                if let productsWithCategories = productsWithCategories {
                    self.productWithCategories = productsWithCategories
                } else {
                    print("Nie udało się pobrać danych")
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
                        print("Błąd dekodowania kategorii")
                        completion(nil)
                    }
                }

                categoriesTask.resume()

            } catch {
                print("Błąd dekodowania produktów")
                completion(nil)
            }
        }

        productsTask.resume()
    }

    func addToCart(_ productWithCategory: ProductWithCategory) {
        shoppingCart.append(productWithCategory)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
