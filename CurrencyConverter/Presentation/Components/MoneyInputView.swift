//
//  MoneyInputView.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 25.06.2022.
//

import UIKit

protocol MoneyInputViewDelegate: AnyObject {
    func textFieldDoneButtonAction(sender: MoneyInputView)
    func currencyDidSelected(with index: Int, sender: MoneyInputView)
}

final class MoneyInputView: UIView {

    // MARK: - Delegates

    weak var delegate: MoneyInputViewDelegate?

    var textFieldDelegate: CustomTextFieldPresenter? {
        didSet {
            amountTextField.delegate = textFieldDelegate
        }
    }

    // MARK: - Properties

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        return stackView
    }()

    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 19, weight: .medium)
        textField.placeholder = Decimal(0).formatted()
        textField.inputAccessoryView = UIToolbar.buildWithDoneButton(
            target: self,
            action: #selector(doneButtonDidTap)
        )

        return textField
    }()

    private lazy var pickerView: PickerView = {
        let pickerView = PickerView(items: currencies, selectedIndex: selectedCurrencyIndex)
        pickerView.delegate = self
        return pickerView
    }()

    private let currencies: [String]
    private let selectedCurrencyIndex: Int

    var showAmountSign = false

    // MARK: - Init

    init(
        currencies: [String] = [],
        selectedCurrencyIndex: Int = 0
    ) {
        self.currencies = currencies
        self.selectedCurrencyIndex = selectedCurrencyIndex
        super.init(frame: .zero)

        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private func prepareUI() {
        stackView.addArrangedSubview(amountTextField)
        if !currencies.isEmpty {
            stackView.addArrangedSubview(pickerView)
        }
        fit(subView: stackView)
    }

    // MARK: - Actions
    
    @objc private func doneButtonDidTap() {
        delegate?.textFieldDoneButtonAction(sender: self)
    }
}

// MARK: - Internal functions

extension MoneyInputView {

    func getAmount() -> Decimal? {
        amountTextField.text?.toDecimal()
    }

    func setText(_ text: String?) {
        if showAmountSign, let text = text, let amount = text.toDecimal() {
            if amount > 0 {
                setAmountTextColor(color: .systemGreen)
                amountTextField.text = "+ \(text)"
            } else if amount < 0 {
                setAmountTextColor(color: .systemRed)
                amountTextField.text = "- \(text)"
            } else {
                setAmountTextColor(color: .label)
                amountTextField.text = text
            }
        } else {
            amountTextField.text = text
        }
    }

    func clear() {
        amountTextField.text = nil
    }

    func setAmountTextColor(color: UIColor) {
        amountTextField.textColor = color
    }
}

// MARK: - PickerViewDelegate

extension MoneyInputView: PickerViewDelegate {

    func didSelected(with index: Int, sender: PickerView) {
        delegate?.currencyDidSelected(with: index, sender: self)
    }
}
