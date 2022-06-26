//
//  SupportedCurrencies.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

public enum SupportedCurrencyType: String, Codable {
    case usd
    case eur
    case jpy
    case sek
}

// MARK: - CustomStringConvertible

extension SupportedCurrencyType: CustomStringConvertible {

    public var description: String {
        self.rawValue.uppercased()
    }
}
