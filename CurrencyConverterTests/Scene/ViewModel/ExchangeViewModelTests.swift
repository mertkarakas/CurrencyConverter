//
//  ExchangeViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Mert Karakas on 26.06.2022.
//

import XCTest
@testable import CurrencyConverter
@testable import CurrencyConversionAPI

final class ExchangeViewModelTests: XCTestCase {
    private var sut: ExchangeViewModel!
    private var exchangeService: MockExchangeService!
    private var controller: ExchangeViewModelController!

    override func setUp() {
        super.setUp()

        exchangeService = MockExchangeService()
        controller = ExchangeViewModelController()
        sut = ExchangeViewModel(exchangeService: exchangeService)
        sut.delegate = controller
    }
}

// MARK: - Service tests

extension ExchangeViewModelTests {

    func testExchangeServiceSuccess() {
        // Given
        sut.selectedSellCurrencyIndex = 0 // EUR
        sut.selectedReceiveCurrencyIndex = 1 // JPY
        exchangeService.response = ExchangeResponse(amount: "123", currency: "JPY")
        let expectation = expectation(description: "exchange service exp")
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        // When
        sut.convert(fromSell: true, amount: 2)

        waitForExpectations(timeout: 5)

        // Then
        XCTAssertEqual(controller.outputs, [
            .updateSellAmount(nil),
            .updateReceiveAmount(nil),
            .setButtonEnable(false),
            .updateSellAmount(nil),
            .updateReceiveAmount(nil),
            .setButtonEnable(false),
            .setLoading(true),
            .updateSellAmount("2.00"),
            .setLoading(false),
            .updateReceiveAmount("123.00"),
            .setButtonEnable(true)
        ])
    }

    func testExchangeServiceFailure() {
        // Given
        sut.selectedSellCurrencyIndex = 0 // EUR
        sut.selectedReceiveCurrencyIndex = 1 // JPY
        exchangeService.response = nil
        let expectation = expectation(description: "exchange service exp")
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        // When
        sut.convert(fromSell: true, amount: 2)

        waitForExpectations(timeout: 5)

        // Then
        XCTAssertEqual(controller.outputs, [
            .updateSellAmount(nil),
            .updateReceiveAmount(nil),
            .setButtonEnable(false),
            .updateSellAmount(nil),
            .updateReceiveAmount(nil),
            .setButtonEnable(false),
            .setLoading(true),
            .updateSellAmount("2.00"),
            .setLoading(false),
            .showAlert(title: "", message: "Something went wrong"),
            .setButtonEnable(false)
        ])
    }
}


fileprivate final class ExchangeViewModelController: ExchangeViewModelDelegate {
    var outputs: [ExchangeViewModelOutput] = []
    func handleViewModelOutputs(_ output: ExchangeViewModelOutput) {
        print(output)
        outputs.append(output)
    }
}

// MARK: - MockExchangeService

fileprivate final class MockExchangeService: ExchangeServiceProtocol {
    var response: ExchangeResponse?
    var success: Bool = false

    func exchange(request: Requestable, completion: @escaping (Result<ExchangeResponse>) -> Void) {

        if let response = response {
            completion(Result.success(response))
            success = true
        } else {
            completion(Result.failure(.init(data: nil)))
        }
    }
}
