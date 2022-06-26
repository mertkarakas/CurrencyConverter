//
//  UserDefaults+Extension.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 26.06.2022.
//

import Foundation

extension UserDefaults {

    private enum Keys {
        static let accountModel = "accountModel"
        static let transactionCount = "transactionCount"
    }

    static var accountModel: Any {
        get {
            UserDefaults.standard.object(forKey: Keys.accountModel) as Any
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.accountModel)
        }
    }

    static var transactionCount: Int? {
        get {
            UserDefaults.standard.object(forKey: Keys.transactionCount) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.transactionCount)
        }
    }
}
