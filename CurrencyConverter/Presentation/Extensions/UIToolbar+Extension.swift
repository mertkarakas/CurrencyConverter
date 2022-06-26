//
//  UIToolbar+Extension.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 25.06.2022.
//

import UIKit

extension UIToolbar {

    static func buildWithDoneButton(target: Any?, action: Selector?) -> UIToolbar {
        let doneToolbar = UIToolbar(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: 50
        ))
        doneToolbar.translatesAutoresizingMaskIntoConstraints = false
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.tintColor = .label
        doneToolbar.barTintColor = .secondarySystemBackground

        var items = [UIBarButtonItem]()
        let flexibleSpaceBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneBarButtonItem = UIBarButtonItem(
            title: "done".localized(),
            style: .done,
            target: target,
            action: action
        )

        items.append(flexibleSpaceBarButtonItem)
        items.append(doneBarButtonItem)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        return doneToolbar
    }
}
