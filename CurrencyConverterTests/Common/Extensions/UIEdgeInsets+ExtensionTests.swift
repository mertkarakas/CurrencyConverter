//
//  UIEdgeInsets+ExtensionTests.swift
//  CurrencyConverterTests
//
//  Created by Mert Karakas on 25.06.2022.
//

import XCTest
@testable import CurrencyConverter

final class UIEdgeInsetsExtensionTests: XCTestCase {

    func testFiniteValue() {
        // When
        let finiteInset = UIEdgeInsets.finiteValue(16)

        XCTAssertEqual(finiteInset, UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
}
