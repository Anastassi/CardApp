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
        let cardModel = CardCollectionViewModel()
        let infoController = InfoController()
        infoController.bindViewModel(cardModel)

        self.viewControllers = [
            UINavigationController(rootViewController: CardController(viewModel: cardModel)),
            UINavigationController(rootViewController: infoController),
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
