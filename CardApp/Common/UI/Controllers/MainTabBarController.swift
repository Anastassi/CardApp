//
//  MainTabBarController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

class MainTabBarController: UITabBarController, TabBarViewDelegate {

    // MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true

        Interface.sh.tabBar.delegate = self

        self.setUpControllers()
    }

    // MARK: - setup

    private func setUpControllers() {
        self.viewControllers = [
            UINavigationController(rootViewController: CardController()),
            UINavigationController(rootViewController: InfoController()),
            UINavigationController(rootViewController: BookmarkController()),
            UINavigationController(rootViewController: SettingsController()),
            UINavigationController(rootViewController: FriendsController())
        ]
        self.selectedViewController = self.viewControllers?[0]
    }

    // MARK: - TabBarViewDelegate

    func didSelectTab(type: TabBarTabType) {
        if type.rawValue == self.selectedIndex {
            Interface.sh.popToRoot()
            return
        }
        self.selectedIndex = type.rawValue
    }
}
