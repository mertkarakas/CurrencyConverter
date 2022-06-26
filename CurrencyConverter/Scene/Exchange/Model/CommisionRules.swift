//
//  CommisionRules.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 26.06.2022.
//

enum CommissionRule {
    case everyNTransaction(n: Int)
    case firstNTransaction(n: Int)
}
