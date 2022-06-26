//
//  UIViewController+Extension.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import UIKit

extension UIViewController {

    public func showAlert(title:String = "error".localized(), message:String?) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)

        let okAction = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default) { action in
            // TODO: - Some action
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
