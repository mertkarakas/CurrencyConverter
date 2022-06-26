//
//  UIViewController+ExtensionTests.swift
//  CurrencyConverterTests
//
//  Created by Mert Karakas on 26.06.2022.
//


import XCTest
@testable import CurrencyConverter

final class UIViewControllerExtensionTests: XCTestCase {
    private var sut: UIViewController!

    override func setUp() {
        super.setUp()

        sut = UIViewController()
        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()
    }

    func testShowAlert() {
        // When

        sut.showAlert(title: "Title", message: "Message")

        // Then
        XCTAssertTrue(sut.presentedViewController is UIAlertController)
    }
}
