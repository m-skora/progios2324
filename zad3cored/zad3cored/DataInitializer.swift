//
//  DataInitializer.swift
//  zad3cored
//
//  Created by mikolaj on 21/12/2023.
//

import CoreData
import Foundation

class DataInitializer {
    static func preloadData(viewContext: NSManagedObjectContext) {
        guard let path = Bundle.main.path(forResource: "fixtures", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let categories = try? JSONDecoder().decode([CategoryFixture].self, from: data) else {
            fatalError("Failed to load fixtures.json")
        }

        for categoryFixture in categories {
            let category = Category(context: viewContext)
            category.name = categoryFixture.category

            for productFixture in categoryFixture.products {
                let product = Product(context: viewContext)
                product.name = productFixture.name
                product.price = productFixture.price
                product.category = category
            }
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Failed to save context: \(nsError), \(nsError.userInfo)")
        }
    }
}


struct CategoryFixture: Decodable {
    let category: String
    let products: [ProductFixture]
}

struct ProductFixture: Decodable {
    let name: String
    let price: Double
}
