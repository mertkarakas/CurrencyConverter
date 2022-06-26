//
//  ExchangeViewModel.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import Foundation
import CurrencyConversionAPI

final class ExchangeViewModel: ExchangeViewModelProtocol {

    // MARK: - Delegates

    weak var delegate: ExchangeViewModelDelegate?

    private(set) lazy var sellTextFieldDelegate: CustomTextFieldPresenter = {
        let config = TextFieldConfig(inputType: .decimal)
        let delegate = CustomTextFieldPresenter(config: config)
        return delegate
    }()

    private(set) lazy var receiveTextFieldDelegate: CustomTextFieldPresenter = {
        let config = TextFieldConfig(inputType: .decimal)
        let delegate = CustomTextFieldPresenter(config: config)
        return delegate
    }()

    // MARK: - Properties

    private let exchangeService: ExchangeServiceProtocol

    private(set) var title = "Currency Converter"

    var selectedSellCurrencyIndex = 0 {
        didSet {
            convert(fromSell: true, amount: sellAmount)
        }
    }
    var selectedReceiveCurrencyIndex = 1 {
        didSet {
            convert(fromSell: false, amount: receiveAmount)
        }
    }
    var sellAmount: Decimal? {
        didSet {
            notifyController(.updateSellAmount(sellAmount?.formatted()))
        }
    }

    var receiveAmount: Decimal? {
        didSet {
            notifyController(.updateReceiveAmount(receiveAmount?.formatted()))
        }
    }

    private var successfulTransactionCount = UserDefaults.transactionCount ?? 0

    // TODO: - Dummy Account model
    private(set) var account: Account = .currentAccount ?? .buildMockAccount()

    // Commission
    private let commissionRules: [CommissionRule] = [.firstNTransaction(n: 5)]
    private let commissionRate: Decimal = 0.7

    private(set) lazy var currencyList: [String] = {
        account.balances
            .sorted(by: { $0.currency.description < $1.currency.description })
            .map({ $0.currency.description })
    }()

    // MARK: - Init

    init(exchangeService: ExchangeServiceProtocol) {
        self.exchangeService = exchangeService
    }

    // MARK: - Private functions

    private func notifyController(_ output: ExchangeViewModelOutput) {
        DispatchQueue.main.async {
            self.delegate?.handleViewModelOutputs(output)
        }
    }
}

// MARK: - Protocol functions

extension ExchangeViewModel {
    /// Check if button should be enable
    func shouldButtonEnable() -> Bool {
        selectedSellCurrencyIndex != selectedReceiveCurrencyIndex &&
        sellAmount ?? 0 > 0 &&
        receiveAmount ?? 0 > 0
    }

    func convert(fromSell: Bool, amount: Decimal?) {
        /// Check if amount is valid
        guard let amount = amount, amount > 0 else {
            sellAmount = nil
            receiveAmount = nil
            notifyController(.setButtonEnable(false))
            return
        }

        /// If currencies are the same then make also amounts are the same and disable the submit button.
        guard selectedSellCurrencyIndex != selectedReceiveCurrencyIndex else {
            if fromSell {
                receiveAmount = sellAmount
            } else {
                sellAmount = receiveAmount
            }
            notifyController(.setButtonEnable(false))
            return
        }

        notifyController(.setLoading(true))

        if fromSell {
            sellAmount = amount
        } else {
            receiveAmount = amount
        }

        let fromCurrency = fromSell ? currencyList[selectedSellCurrencyIndex] : currencyList[selectedReceiveCurrencyIndex]
        let toCurrency = fromSell ? currencyList[selectedReceiveCurrencyIndex] : currencyList[selectedSellCurrencyIndex]

        let request = ExchangeRequest(fromAmount: amount.formatted(), fromCurrency: fromCurrency, toCurrency: toCurrency)

        exchangeService.exchange(request: request) { [weak self] (result) in
            guard let self = self else {
                return
            }
            self.notifyController(.setLoading(false))

            switch result {
            case .success(let response):
                guard let amount = response.amount.toDecimal(locale: .init(identifier: "en_US")) else {
                    return
                }
                if fromSell {
                    self.receiveAmount = amount
                } else {
                    self.sellAmount = amount
                }
            case .failure(let error):
                self.notifyController(.showAlert(title: error.serviceError.error, message: error.serviceError.error_description))
            }

            self.notifyController(.setButtonEnable(self.shouldButtonEnable()))
        }
    }

    func loadAccountBalances() -> [Balance] {
        account.balances.sorted(by: { $0.amount > $1.amount })
    }

    func submit() {
        guard shouldButtonEnable(),
              let sellAmount = sellAmount,
              let receiveAmount = receiveAmount else {
            return
        }

        let sellCurrency = currencyList[selectedSellCurrencyIndex]
        let receiveCurrency = currencyList[selectedReceiveCurrencyIndex]

        guard let sellBalanceIndex = account.balances.firstIndex(where: { $0.currency.description == sellCurrency }) else {
            return
        }

        guard let receiveBalanceIndex = account.balances.firstIndex(where: { $0.currency.description == receiveCurrency }) else {
            return
        }

        var balanceAmountToSell = account.balances[sellBalanceIndex].amount
        var balanceAmountToReceive = account.balances[receiveBalanceIndex].amount

        let commission = shouldApplyCommission()
        ? commissionRate.dividedBy(100).adding(1)
        : 1

        guard let sellAmountWithCommision = sellAmount.multiply(commission).withTwoFractions() else {
            return
        }

        guard balanceAmountToSell >= sellAmountWithCommision else {
            self.notifyController(.showAlert(title: "error".localized(), message: "insufficient_balance".localized()))
            return
        }

        balanceAmountToSell = balanceAmountToSell.subtracting(sellAmountWithCommision)
        balanceAmountToReceive = balanceAmountToReceive.adding(receiveAmount)

        account.balances[sellBalanceIndex].amount = balanceAmountToSell
        account.balances[receiveBalanceIndex].amount = balanceAmountToReceive
        account.saveAccount()

        successfulTransactionCount += 1
        UserDefaults.transactionCount = successfulTransactionCount

        notifyController(.accountUpdated)
        notifyController(.showAlert(
            title: "",
            message: String(format: "converted_message".localized(),
                            sellAmount.formatted(currencySymbol: sellCurrency.description),
                            receiveAmount.formatted(currencySymbol: receiveCurrency.description),
                            (sellAmountWithCommision.subtracting(sellAmount)).formatted(currencySymbol: sellCurrency.description)
                           )))

        self.sellAmount = nil
        self.receiveAmount = nil

        notifyController(.updateReceiveAmount(nil))
        notifyController(.updateSellAmount(nil))
        notifyController(.setButtonEnable(false))
    }
}

// MARK: - Commision Calculator

private extension ExchangeViewModel {

    func shouldApplyCommission() -> Bool {

        for rule in commissionRules {
            switch rule {
            case .everyNTransaction(let n):
                if (successfulTransactionCount + 1) % n == 0 {
                    return false
                }
            case .firstNTransaction(let n):
                if (successfulTransactionCount + 1) <= n {
                    return false
                }
            }
        }
        return true
    }
}
