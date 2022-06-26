//
//  DependencyContainer.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import UIKit
import CurrencyConversionAPI

final class DependencyContainer {
    let window: UIWindow
    let serviceManager: ServiceManager

    init(window: UIWindow, serviceManager: ServiceManager) {
        self.window = window
        self.serviceManager = serviceManager
    }
}
