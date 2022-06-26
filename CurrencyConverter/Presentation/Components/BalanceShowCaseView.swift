//
//  BalanceShowCaseView.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 26.06.2022.
//

import UIKit

final class BalanceShowCaseView: UIView {

    // MARK: - Constants

    private enum Layouts {
        static let viewHeight: CGFloat = 125
        static let bgViewWidth: CGFloat = 200
        static let stackSpacing: CGFloat = 18
        static let standardPadding: CGFloat = 16
        static let headerViewHeight: CGFloat = 40
    }

    private let contentView = UIView()

    private let scrollView = UIScrollView()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Layouts.stackSpacing
        return stackView
    }()

    private let balances: [Balance]

    private var balanceViews: [UUID: BalanceView] = [:]

    init(balances: [Balance]) {
        self.balances = balances
        super.init(frame: .zero)

        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareUI() {
        let headerView = UIView.generateHeaderView(
            text: "\("my_balances".localized()) (\(balances.count))"
        )
        translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        fit(subView: contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(scrollView)

        let stackContainerView = UIView()
        stackContainerView.fit(subView: stackView, withPadding: .finiteValue(Layouts.standardPadding))

        scrollView.fit(subView: stackContainerView)

        let constraints: [NSLayoutConstraint] = [
            heightAnchor.constraint(equalToConstant: Layouts.viewHeight),
            scrollView.heightAnchor.constraint(equalTo: stackContainerView.heightAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        for balance in balances {
            let balanceView = generateBalanceBg(balance: balance.formatted, bgColor: balance.bgColor.color)
            balanceViews[balance.balanceId] = balanceView
            stackView.addArrangedSubview(balanceView)
        }
    }

    private func generateBalanceBg(balance: String, bgColor: UIColor) -> BalanceView {
        let balanceBgView = BalanceView(balance: balance, bgColor: bgColor)
        balanceBgView.widthAnchor.constraint(equalToConstant: Layouts.bgViewWidth).isActive = true

        return balanceBgView
    }
}

// MARK: - Internals

extension BalanceShowCaseView {

    func updateBalances(with balances: [Balance]) {
        for (index, balance) in balances.enumerated() {
            guard let balanceView = balanceViews[balance.balanceId] else {
                return
            }
            balanceView.updateBalance(balanceString: balance.formatted)

            if let stackIndex = stackView.arrangedSubviews.firstIndex(where: { $0 == balanceView }),
               stackIndex != index {
                stackView.removeArrangedSubview(balanceView)
                stackView.insertArrangedSubview(balanceView, at: index)
            }
        }
    }
}
