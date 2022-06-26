//
//  AppCoordinator.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import UIKit
import CurrencyConversionAPI

protocol CoordinatorProtocol {
    func start()
}

final class AppCoordinator: CoordinatorProtocol {

    private let dependencies: DependencyContainer
    var rootViewController: UINavigationController!

    init(dependencies: DependencyContainer) {
        self.dependencies = dependencies
    }

    func start() {
        let viewModel = ExchangeViewModel(exchangeService: ExchangeService(manager: dependencies.serviceManager))
        let viewController = ExchangeViewController(viewModel: viewModel)
        rootViewController = UINavigationController(rootViewController: viewController)
    }
}

