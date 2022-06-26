//
//  IndicatorViewTests.swift
//  CurrencyConverterTests
//
//  Created by Mert Karakas on 24.06.2022.
//

import XCTest
@testable import CurrencyConverter

final class IndicatorViewTests: XCTestCase {
    private var sut: IndicatorView!

    override func setUp() {
        super.setUp()
        sut = IndicatorView()
    }

    func testUserInteraction() {
        // Then
        XCTAssertFalse(sut.isUserInteractionEnabled)
    }

    func testHasActivityView() {
        // Given
        let activityView = sut.subviews.first?.subviews.first(where: { $0 is UIActivityIndicatorView })

        // Then
        XCTAssertNotNil(activityView)
    }
}
