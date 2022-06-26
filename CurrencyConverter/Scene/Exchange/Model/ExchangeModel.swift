//
//  ExchangeModel.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 25.06.2022.
//

import Foundation
import CurrencyConversionAPI
import UIKit

struct Account: Codable {
    var balances: [Balance]
    
    static var currentAccount: Account? {
        guard let data = UserDefaults.accountModel as? Data,
              let account = try? PropertyListDecoder().decode(Account.self, from: data) else {
            return nil
        }
        return account
    }

    func saveAccount() {
        guard let encodedAccount = try? PropertyListEncoder().encode(self) else {
            return
        }
        UserDefaults.accountModel = encodedAccount
    }
}

struct Balance: Codable {
    let balanceId: UUID
    var amount: Decimal
    let currency: SupportedCurrencyType
    let bgColor: BalanceColor

    var formatted: String {
        amount.formatted(currencySymbol: currency.description)
    }
}

enum BalanceColor: Codable {
    case green
    case red
    case blue

    var color: UIColor {
        switch self {
        case .green:
            return .systemGreen
        case .red:
            return .systemRed
        case .blue:
            return .systemBlue
        }
    }
}

// MARK: - Mock Account

extension Account {

    static func buildMockAccount() -> Account {
        Account(
            balances: [
                Balance(balanceId: UUID(), amount: 0, currency: .usd, bgColor: .green),
                Balance(balanceId: UUID(), amount: 0, currency: .jpy, bgColor: .red),
                Balance(balanceId: UUID(), amount: 1000, currency: .eur, bgColor: .blue),
            ])
    }
}
