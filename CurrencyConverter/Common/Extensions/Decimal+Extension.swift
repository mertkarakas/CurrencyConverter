//
//  Decimal+Extension.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 25.06.2022.
//

import Foundation

extension Decimal {

    func formatted(
        maximumFractionDigits: Int = 2,
        minimumFractionDigits: Int = 2,
        currencySymbol: String? = nil
    ) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.minimumFractionDigits = minimumFractionDigits

        guard let currencySymbol = currencySymbol else {
            return formatter.string(for: self) ?? ""
        }

        return "\(formatter.string(for: self) ?? "") \(currencySymbol)"
    }

    func withTwoFractions() -> Decimal? {
        return self.formatted().toDecimal()
    }

    func adding(_ with: Decimal) -> Decimal {
        (self as NSDecimalNumber).adding(NSDecimalNumber(decimal: with)) as Decimal
    }

    func subtracting(_ with: Decimal) -> Decimal {
        (self as NSDecimalNumber).subtracting(NSDecimalNumber(decimal: with)) as Decimal
    }

    func dividedBy(_ with: Decimal) -> Decimal {
        (self as NSDecimalNumber).dividing(by: (NSDecimalNumber(decimal: with))) as Decimal
    }

    func multiply(_ with: Decimal) -> Decimal {
        (self as NSDecimalNumber).multiplying(by: (NSDecimalNumber(decimal: with))) as Decimal
    }
}
