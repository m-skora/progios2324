//
//  ContentView.swift
//  zad5auth
//
//  Created by mikolaj on 07/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    LoggedInView(username: username, onLogout: { logout() })
                } else {
                    LoginView(
                        username: $username,
                        password: $password,
                        isLoggedIn: $isLoggedIn,
                        showAlert: $showAlert,
                        onLogin: { login() }
                    )
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Login Failed"),
                            message: Text("Please try again."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .padding()
            .navigationTitle(isLoggedIn ? "Logged In" : "Login")
        }
    }

    func login() {
        let loginURL = URL(string: "http://127.0.0.1:5000/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let credentials = ["username": username, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: credentials) else {
            return
        }

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = jsonResponse as? [String: Any], let message = jsonDict["message"] as? String {
                    print("Server Response: \(message)")

                    if message == "login successful" {
                        isLoggedIn = true
                    } else {
                        showAlert = true
                    }
                }
            }
        }.resume()
    }

    func logout() {
        isLoggedIn = false
    }
}

struct LoggedInView: View {
    let username: String
    let onLogout: () -> Void

    var body: some View {
        VStack {
            Text("Welcome, \(username)!")
                .padding()

            Button("Logout") {
                onLogout()
            }
            .foregroundColor(.red)
        }
    }
}

struct LoginView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isLoggedIn: Bool
    @Binding var showAlert: Bool
    var onLogin: () -> Void

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()

            SecureField("Password", text: $password)
                .padding()

            Button("Login") {
                onLogin()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
