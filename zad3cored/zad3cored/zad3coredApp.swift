//
//  zad3coredApp.swift
//  zad3cored
//
//  Created by mikolaj on 21/12/2023.
//

import SwiftUI
@main
struct zad3coredApp: App {
    let coreDataStack = CoreDataStack()
    
    var body: some Scene {
        WindowGroup {
            ProductsView()
                .environment(\.managedObjectContext, coreDataStack.viewContext)
        }
    }
}
