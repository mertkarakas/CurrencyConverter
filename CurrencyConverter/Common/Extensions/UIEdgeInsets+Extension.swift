//
//  UIEdgeInsets+Extension.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 25.06.2022.
//

import Foundation
import UIKit

extension UIEdgeInsets {

    static func finiteValue(_ value: CGFloat) -> Self {
        UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
}
