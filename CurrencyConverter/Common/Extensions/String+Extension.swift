//
//  String+Extension.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import Foundation

extension String {

    public func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    public func toDecimal(locale: Locale = .current) -> Decimal? {
        guard !self.isEmpty else {
            return nil
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        let number = numberFormatter.number(from: self)
        return number?.decimalValue ?? nil
    }
}
