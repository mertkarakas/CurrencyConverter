//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 23.06.2022.
//

import UIKit
import CurrencyConversionAPI

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: CoordinatorProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Bring back the old navigation bar style.
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        let window = UIWindow()
        let serviceManager = ServiceManager()
        let dependencies = DependencyContainer(window: window, serviceManager: serviceManager)

        let appCoordinator = AppCoordinator(dependencies: dependencies)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        self.window = window

        window.rootViewController = appCoordinator.rootViewController
        window.makeKeyAndVisible()
        
        return true
    }
}
