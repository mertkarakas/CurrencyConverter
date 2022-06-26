//
//  ExchangeViewController.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import Foundation
import UIKit

final class ExchangeViewController: UIViewController {

    // MARK: - Constants

    private enum Layouts {
        static let stackViewPaddingSmall: CGFloat = 8
        static let stackViewPadding: CGFloat = 16
        static let submitButtonFont: UIFont = .systemFont(ofSize: 17, weight: .medium)
        static let buttonHeight: CGFloat = 50
    }

    // MARK: - Properties

    private var viewModel: ExchangeViewModelProtocol!

    // MARK: - UI Properties

    private let contentView = UIView()

    private let scrollView = UIScrollView()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layouts.stackViewPadding
        return stackView
    }()

    private lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .roundedRect)
        submitButton.backgroundColor = .systemBackground
        submitButton.setTitle("submit".localized(), for: .normal)
        submitButton.titleLabel?.font = Layouts.submitButtonFont
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        submitButton.isEnabled = false
        return submitButton
    }()

    private var balanceShowCaseView: BalanceShowCaseView!

    private lazy var sellAmount: MoneyInputView = {
        let sellAmount = MoneyInputView(currencies: viewModel.currencyList, selectedCurrencyIndex: viewModel.selectedSellCurrencyIndex)
        sellAmount.textFieldDelegate = viewModel.sellTextFieldDelegate
        sellAmount.delegate = self
        sellAmount.setContentHuggingPriority(.defaultLow, for: .horizontal)
        sellAmount.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return sellAmount
    }()

    private lazy var receiveAmount: MoneyInputView = {
        let receiveAmount = MoneyInputView(currencies: viewModel.currencyList, selectedCurrencyIndex: viewModel.selectedReceiveCurrencyIndex)
        receiveAmount.delegate = self
        receiveAmount.showAmountSign = true
        receiveAmount.textFieldDelegate = viewModel.receiveTextFieldDelegate
        receiveAmount.setContentHuggingPriority(.defaultLow, for: .horizontal)
        receiveAmount.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return receiveAmount
    }()

    // MARK: - Init

    convenience init(viewModel: ExchangeViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self

        /// Call conversion when text fields end editing.
        viewModel.sellTextFieldDelegate.textFieldDidEndEditing = { [weak self] in
            guard let self = self else {
                return
            }
            viewModel.convert(fromSell: true, amount: self.sellAmount.getAmount())
        }

        viewModel.receiveTextFieldDelegate.textFieldDidEndEditing = { [weak self] in
            guard let self = self else {
                return
            }
            viewModel.convert(fromSell: false, amount: self.receiveAmount.getAmount())
        }

        /// Clear fields when did begin editing
        viewModel.sellTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            self?.sellAmount.clear()
        }

        viewModel.receiveTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            self?.receiveAmount.clear()
        }
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        buildObservers()

        prepareUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UI

    private func prepareUI() {
        view.backgroundColor = .secondarySystemBackground
        title = viewModel.title
        
        view.fit(subView: scrollView)
        scrollView.fit(subView: contentView)
        contentView.fit(subView: stackView)

        let constraints: [NSLayoutConstraint] = [
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        balanceShowCaseView = BalanceShowCaseView(balances: viewModel.loadAccountBalances())
        stackView.addArrangedSubview(balanceShowCaseView)

        buildExchangeView()
        buildButton()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gesture)
    }

    private func buildExchangeView() {
        let exchangeHeaderView = UIView.generateHeaderView(text: "currency_exchange".localized())
        stackView.addArrangedSubview(exchangeHeaderView)

        let sellLabel = UILabel()
        sellLabel.text = "sell".localized()
        sellLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let receiveLabel = UILabel()
        receiveLabel.text = "receive".localized()
        receiveLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        receiveLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let sellIcon = UIImageView(image: .init(systemName: "arrow.up.circle.fill"))
        sellIcon.tintColor = .systemRed
        sellIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let receiveIcon = UIImageView(image: .init(systemName: "arrow.down.circle.fill"))
        receiveIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        receiveIcon.tintColor = .systemGreen

        let exchangeSellAmountStack = UIStackView(arrangedSubviews: [
            sellIcon,
            sellLabel,
            sellAmount
        ])
        exchangeSellAmountStack.spacing = Layouts.stackViewPaddingSmall

        let exchangeReceiveAmountStack = UIStackView(arrangedSubviews: [
            receiveIcon,
            receiveLabel,
            receiveAmount
        ])
        exchangeReceiveAmountStack.spacing = Layouts.stackViewPaddingSmall

        let exchangeContainerView = UIView()
        let exchangeStack = UIStackView(arrangedSubviews: [exchangeSellAmountStack, exchangeReceiveAmountStack])
        exchangeStack.axis = .vertical
        exchangeStack.spacing = Layouts.buttonHeight
        exchangeContainerView.fit(subView: exchangeStack, withPadding: .finiteValue(Layouts.stackViewPadding))

        stackView.addArrangedSubview(exchangeContainerView)
    }

    private func buildButton() {
        let buttonContainerView = UIView()
        buttonContainerView.heightAnchor.constraint(equalToConstant: Layouts.buttonHeight).isActive = true

        let submitButtonStack = UIStackView(arrangedSubviews: [submitButton])
        buttonContainerView.fit(subView: submitButtonStack)

        stackView.addArrangedSubview(buttonContainerView)
    }
}

// MARK: - ExchangeViewModelDelegate

extension ExchangeViewController: ExchangeViewModelDelegate {

    func handleViewModelOutputs(_ output: ExchangeViewModelOutput) {

        switch output {
        case .setLoading(let show):
            navigationController?.view.setLoading(show)
        case .showAlert(let title, let message):
            showAlert(title: title, message: message)
        case .accountUpdated:
            NotificationCenter.default.post(name: .accountUpdated, object: nil)
        case .setButtonEnable(let enable):
            submitButton.isEnabled = enable
        case .updateSellAmount(let amountStr):
            sellAmount.setText(amountStr)
        case .updateReceiveAmount(let amountStr):
            receiveAmount.setText(amountStr)
        }
    }
}

// MARK: - MoneyInputViewDelegate

extension ExchangeViewController: MoneyInputViewDelegate {

    func textFieldDoneButtonAction(sender: MoneyInputView) {
        view.endEditing(true)
    }

    func currencyDidSelected(with index: Int, sender: MoneyInputView) {
        if sender == sellAmount {
            viewModel.selectedSellCurrencyIndex = index
        } else if sender == receiveAmount {
            viewModel.selectedReceiveCurrencyIndex = index
        }
    }
}

// MARK: - Observers

private extension ExchangeViewController {
    /// Notifications
    func buildObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accountUpdated),
            name: .accountUpdated,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardShown),
            name: .keyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: .keyboardWillHide,
            object: nil
        )
    }
}

// MARK: - Actions

private extension ExchangeViewController {

    @objc func accountUpdated(_ notification: Notification) {
        balanceShowCaseView.updateBalances(with: viewModel.loadAccountBalances())
    }

    @objc func submitAction() {
        viewModel.submit()
    }

    @objc func keyboardShown() {
        submitButton.isEnabled = false
    }

    @objc func keyboardWillHide() {
        submitButton.isEnabled = viewModel.shouldButtonEnable()
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }
}
