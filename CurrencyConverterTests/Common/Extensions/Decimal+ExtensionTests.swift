//
//  Decimal+ExtensionTests.swift
//  CurrencyConverterTests
//
//  Created by Mert Karakas on 25.06.2022.
//

import XCTest
@testable import CurrencyConverter

final class DecimalExtensionTests: XCTestCase {
    private let decimal1 = Decimal(49.41)
    private let decimal2 = Decimal(55.86)
    private let decimalSeparator = Locale.current.decimalSeparator ?? "."

    func testAdding() {
        // Then
        XCTAssertEqual(decimal1.adding(decimal2), Decimal(105.27))
    }

    func testSubtracting() {
        // Then
        XCTAssertEqual(decimal1.subtracting(decimal2), Decimal(-6.45))
    }

    func testFormatter() {
        // Then
        XCTAssertEqual(decimal1.formatted(currencySymbol: nil), "49\(decimalSeparator)41")

        // Then - with parameters
        XCTAssertEqual(
            decimal1.adding(decimal2).formatted(maximumFractionDigits: .zero, minimumFractionDigits: .zero),
            "105"
        )

        // Then - with symbol
        XCTAssertEqual(decimal1.formatted(currencySymbol: "EUR"), "49\(decimalSeparator)41 EUR")
    }
}
