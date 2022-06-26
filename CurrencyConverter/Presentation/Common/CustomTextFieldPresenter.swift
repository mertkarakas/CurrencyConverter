//
//  CustomTextFieldDelegate.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 25.06.2022.
//

import UIKit

enum InputType {
    case alphanumeric(allowWhiteSpace: Bool = true)
    case numeric
    case decimal
}

struct TextFieldConfig {
    let inputType: InputType
    var maxLength: Int = 10

    init(inputType: InputType, maxLength: Int = 10) {
        self.inputType = inputType
        self.maxLength = maxLength
    }
}

final class CustomTextFieldPresenter: NSObject {

    var shouldChangeCharacters: ((String) -> Void)?
    var textFieldDidEndEditing: (() -> Void)?
    var textFieldDidBeginEditing: (() -> Void)?

    private let config: TextFieldConfig

    public init(config: TextFieldConfig) {
        self.config = config
    }
}

// MARK: - UITextFieldDelegates

extension CustomTextFieldPresenter: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }

        switch config.inputType {
        case .decimal:
            // Accept chars if it is number or contains only 1 decimal separator.
            if !string.isEmpty &&
                !string.contains(where: { $0.isNumber || Locale.current.decimalSeparator == String($0) }) {
                return false
            }
            if (textFieldText.appending(string).filter({ Locale.current.decimalSeparator == String($0) }).count > 1) {
                return false
            }
        case .numeric:
            // Accept chars if it is number only.
            if !string.isEmpty && !string.contains(where: { $0.isNumber }) {
                return false
            }
        case .alphanumeric(let allowWhiteSpace):
            // Accept chars and numbers.
            let invalidChars = allowWhiteSpace
            ? CharacterSet.alphanumerics.inverted.subtracting(CharacterSet.whitespaces)
            : CharacterSet.alphanumerics.inverted
            return string.rangeOfCharacter(from: invalidChars) == nil
        }

        let fullText = textFieldText.replacingCharacters(in: rangeOfTextToReplace, with: string)

        guard fullText.count <= config.maxLength else {
            return false
        }

        shouldChangeCharacters?(fullText)

        textField.text = fullText

        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditing?()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidBeginEditing?()
    }
}
