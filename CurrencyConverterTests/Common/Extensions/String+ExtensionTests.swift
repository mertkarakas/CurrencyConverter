//
//  String+ExtensionTests.swift
//  CurrencyConverterTests
//
//  Created by Mert Karakas on 25.06.2022.
//

import XCTest
@testable import CurrencyConverter

final class StringExtensionTests: XCTestCase {

    func testLocalized() {
        let localizedText = "ok".localized()

        if Locale.current.languageCode == "tr" {
            XCTAssertEqual(localizedText, "Tamam")
        } else {
            XCTAssertEqual(localizedText, "OK")
        }
    }
}
