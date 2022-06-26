//
//  Notification+Extension.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 26.06.2022.
//

import Foundation
import UIKit.UIResponder

extension Notification.Name {
    static let accountUpdated = NSNotification.Name("AccountUpdated")
    static let keyboardWillShow = UIResponder.keyboardWillShowNotification
    static let keyboardWillHide = UIResponder.keyboardWillHideNotification
}
