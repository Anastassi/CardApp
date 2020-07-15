//
//  Interface.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

class Interface {

    static let sh = Interface()

    let navController = TabBarController()

    var tabBar: TabBarView {
        return self.navController.tabBarView
    }

    var topController: UIViewController? {
        if let tabVC = self.navController.topViewController as? MainTabBarController,
            let navController = tabVC.selectedViewController as? UINavigationController {
            return navController.topViewController
        } else {
            return self.navController.topViewController
        }
    }

    private weak var window: UIWindow?

    // MARK: - init

    private init() {}

    // MARK: - setup

    func setup(window: UIWindow) {
        self.window = window

        self.setUpNavigationBarStyle()

        window.rootViewController = self.navController
        if DefaultsManager.didPassOnboarding {
            self.setVC(MainTabBarController())
        } else {
            self.setVC(OnboardingController())
        }

        window.makeKeyAndVisible()
    }

    private func setUpNavigationBarStyle() {
        let standartNavBar = UINavigationBar.appearance()
        standartNavBar.backgroundColor = .white
        standartNavBar.tintColor = .systemPurple
        standartNavBar.prefersLargeTitles = true

        let newNavBar = UINavigationBarAppearance()
        newNavBar.configureWithDefaultBackground()

        standartNavBar.scrollEdgeAppearance = newNavBar
        standartNavBar.standardAppearance = newNavBar
    }

    // MARK: - navigation

    func pushVC(_ viewController: UIViewController, animated: Bool = true) {
        self.navController.pushViewController(viewController, animated: animated)
    }

    func popVC() {
        self.navController.popViewController(animated: true)
    }

    func popToVC(_ vc: UIViewController) {
        self.navController.popToViewController(vc, animated: true)
    }

    func popToRoot(animated: Bool = true) {
        self.navController.popToRoot(animated: animated)
    }

    func setVC(_ viewController: UIViewController, forced: Bool = false) {
        self.navController.setViewControllers([viewController], animated: true, forced: forced)
    }

    func selectTabBar(item: TabBarTabType) {
        self.tabBar.select(item: item)
    }
}
