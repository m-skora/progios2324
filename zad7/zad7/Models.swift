//
//  Models.swift
//  zad6
//
//  Created by mikolaj on 30/01/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

struct Product: Codable {
    let id: Int
    let name: String
    let category_id: Int
    let price: Double
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

struct OrderData: Codable {
    let products: [Product]
    let token: String
}

struct PaymentData: Codable {
    let cardNumber: String
    let expiryDate: String
    let cvv: String
}

struct TokenResponse: Codable {
    let token: String
}
