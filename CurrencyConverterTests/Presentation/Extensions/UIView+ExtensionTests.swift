//
//  UIView+ExtensionTests.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 26.06.2022.
//

import XCTest
@testable import CurrencyConverter

final class UIViewExtensionTests: XCTestCase {
    private var sut: UIView!

    override func setUp() {
        super.setUp()

        sut = UIView()
    }

    func testShowIndicator() {
        // When
        sut.setLoading(true)

        // Then
        XCTAssertTrue(sut.subviews.first is IndicatorView)
    }

    func testHideIndicator() {
        // When
        sut.setLoading(true)
        sut.setLoading(false)

        // Then
        XCTAssertFalse(sut.subviews.first is IndicatorView)
    }

}
