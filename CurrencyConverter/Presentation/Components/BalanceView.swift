//
//  AccountBackgroundView.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 26.06.2022.
//

import UIKit

final class BalanceView: UIView {

    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        return label
    }()

    private let bgColor: UIColor
    private let balance: String

    init(balance: String, bgColor: UIColor) {
        self.bgColor = bgColor
        self.balance = balance
        super.init(frame: .zero)

        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareUI() {
        backgroundColor = bgColor
        layer.cornerRadius = 20
        balanceAmountLabel.text = balance

        fit(subView: balanceAmountLabel, withPadding: .finiteValue(16))
    }
}

// MARK: - Internals

extension BalanceView {

    func updateBalance(balanceString: String) {
        balanceAmountLabel.text = balanceString
    }
}
