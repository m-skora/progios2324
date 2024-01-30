//
//  zad7UITests.swift
//  zad7UITests
//
//  Created by mikolaj on 30/01/2024.
//

import XCTest

final class zad7UITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testProductListScrolling() throws {
        let productList = app.tables["productListIdentifier"]
        productList.swipeUp()
    }

    func testProductDetailsDisplay() throws {
        let productCell = app.tables["productListIdentifier"].cells.firstMatch
        productCell.tap()
        XCTAssertTrue(app.staticTexts["Nazwa:"].exists)
        XCTAssertTrue(app.staticTexts["Kategoria:"].exists)
        XCTAssertTrue(app.staticTexts["Cena:"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func testAddMultipleProductsToCart() throws {
        let productCells = app.tables.cells
        let addToCartButton = app.buttons["Do koszyka"]

        for index in 0..<productCells.count {
            let productCell = productCells.element(boundBy: index)
            productCell.tap()
            addToCartButton.tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        let goToCartElement = app.otherElements["Przejdź do koszyka"]
        XCTAssertTrue(goToCartElement.exists)
        goToCartElement.tap()
        XCTAssertEqual(app.tables.cells.count, productCells.count)
    }

    func testAddToCartFromProductList() throws {
        let addToCartButton = app.buttons.element(boundBy: 0)
        addToCartButton.tap()
        let goToCartElement = app.otherElements["Przejdź do koszyka"]
        XCTAssertTrue(goToCartElement.exists)
        goToCartElement.tap()
        XCTAssertEqual(app.tables.cells.count, 1)
    }

    func testNavigateToPaymentView() throws {
        let addToCartButton = app.buttons.element(boundBy: 0)
        addToCartButton.tap()
        let goToCartElement = app.otherElements["Przejdź do koszyka"]
        goToCartElement.tap()

        XCTAssertTrue(app.staticTexts["Koszyk"].exists)
        XCTAssertTrue(app.staticTexts["Suma:"].exists)
        XCTAssertTrue(app.buttons["Złóż zamówienie"].exists)
    }

    func testPaymentSuccess() throws {
        let addToCartButton = app.buttons.element(boundBy: 0)
        addToCartButton.tap()
        let goToCartElement = app.otherElements["Przejdź do koszyka"]
        XCTAssertTrue(goToCartElement.exists)
        goToCartElement.tap()
        app.buttons["Złóż zamówienie"].tap()
        XCTAssertTrue(app.alerts["Sukces"].exists)
        XCTAssertTrue(app.alerts["Płatność zakończona sukcesem."].exists)
        app.alerts["Sukces"].buttons["OK"].tap()
    }

    func testPaymentFailure() throws {
        let addToCartButton = app.buttons.element(boundBy: 0)
        addToCartButton.tap()
        let goToCartElement = app.otherElements["Przejdź do koszyka"]
        XCTAssertTrue(goToCartElement.exists)
        goToCartElement.tap()
        app.textFields["Numer karty"].typeText("1234567812345670")
        app.textFields["Data ważności"].typeText("12/24")
        app.textFields["CVV"].typeText("123")
        app.buttons["Zapłać"].tap()
        XCTAssertTrue(app.alerts["Błąd płatności"].exists)
        XCTAssertTrue(app.alerts["Wystąpił błąd podczas przetwarzania płatności:"].exists)
        app.alerts["Błąd płatności"].buttons["OK"].tap()
    }
}
