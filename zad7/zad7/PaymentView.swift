//
//  PaymentView.swift
//  zad7
//
//  Created by mikolaj on 30/01/2024.
//

import SwiftUI

struct PaymentView: View {
    var shoppingCart: [ProductWithCategory] = []
    
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var paymentToken: String?
    
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

            TextField("Numer karty", text: $cardNumber)
                .padding()
            TextField("Data ważności", text: $expiryDate)
                .padding()
            TextField("CVV", text: $cvv)
                .padding()
            
            Button("Zapłać") {
                if validateCreditCardNumber(cardNumber) && validateExpiryDate(expiryDate) && validateCVV(cvv) {
                    sendPayment { result in
                        switch result {
                        case .success(let token):
                            self.paymentToken = token
                            showAlert(title: "Sukces", message: "Płatność zakończona sukcesem.")
                            sendOrder(paymentToken: token) { orderResult in
                                switch orderResult {
                                case .success:
                                    showAlert(title: "Zamówienie", message: "Zamówienie zrealizowane poprawnie.")
                                case .failure(let error):
                                    showAlert(title: "Błąd zamówienia", message: "Wystąpił błąd podczas tworzenia zamówienia: \(error.localizedDescription)")
                                }
                            }
                        case .failure(let error):
                            showAlert(title: "Błąd płatności", message: "Wystąpił błąd podczas przetwarzania płatności: \(error.localizedDescription)")
                        }
                    }
                } else {
                    showAlert(title: "Błąd walidacji", message: "Wprowadź poprawne dane płatności.")
                }
            }
            .padding()
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func validateCreditCardNumber(_ cardNumber: String) -> Bool {
        return cardNumber.count == 16 && cardNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func validateExpiryDate(_ expiryDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: expiryDate) != nil
    }
    
    func validateCVV(_ cvv: String) -> Bool {
        return cvv.count == 3 && cvv.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func sendPayment(completion: @escaping (Result<String, Error>) -> Void) {
            guard let url = URL(string: "http://127.0.0.1:5000/processPayment") else {
                completion(.failure(NetworkError.invalidURL))
                return
            }

            let paymentData = PaymentData(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cvv: cvv
            )

            do {
                let jsonData = try JSONEncoder().encode(paymentData)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                            completion(.success(tokenResponse.token))
                        } catch {
                            print("Decoding error:", error)
                            completion(.failure(NetworkError.decodingError))
                        }
                    }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }

    
    func sendOrder(paymentToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/api/orders") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let orderData = OrderData(
            products: shoppingCart.map { productWithCategory in
                Product(
                    id: productWithCategory.product.id,
                    name: productWithCategory.product.name,
                    category_id: productWithCategory.product.category_id,
                    price: productWithCategory.product.price
                )
            },
            token: paymentToken
        )

        
        do {
            let jsonData = try JSONEncoder().encode(orderData)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending order request: \(error)")
                    completion(.failure(error))
                } else if let response = response as? HTTPURLResponse {
                    print("Order request successful with status code: \(response.statusCode)")
                    if let data = data {
                        print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                    completion(.success(()))
                }
            }.resume()

        } catch {
            completion(.failure(error))
        }
    }
}
