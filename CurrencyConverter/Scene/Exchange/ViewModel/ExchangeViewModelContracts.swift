//
//  ExchangeViewModelContracts.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import Foundation

protocol ExchangeViewModelProtocol {
    var delegate: ExchangeViewModelDelegate? { get set }
    var title: String { get }
    var sellTextFieldDelegate: CustomTextFieldPresenter { get }
    var receiveTextFieldDelegate: CustomTextFieldPresenter { get }
    var currencyList: [String] { get }
    var selectedSellCurrencyIndex: Int { get set }
    var selectedReceiveCurrencyIndex: Int { get set }

    func loadAccountBalances() -> [Balance]
    func convert(fromSell: Bool, amount: Decimal?)
    func submit()
    func shouldButtonEnable() -> Bool
}

protocol ExchangeViewModelDelegate: AnyObject {
    func handleViewModelOutputs(_ output: ExchangeViewModelOutput)
}

enum ExchangeViewModelOutput: Equatable {
    case setLoading(Bool)
    case showAlert(title: String, message: String)
    case accountUpdated
    case setButtonEnable(Bool)
    case updateSellAmount(String?)
    case updateReceiveAmount(String?)
}
