//
//  TabBarCellModel.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

class AMTabBarCellModel {

    // MARK: - parameters

    let activeImage: String
    let inactiveImage: String
    let type: TabBarTabType

    let selectedItemTintColor: UIColor
    let unselectedItemTintColor: UIColor?

    var isActive: Bool

    // MARK: - init

    init(type: TabBarTabType,
         selectedItemTintColor: UIColor = .red,
         unselectedItemTintColor: UIColor? = nil,
         isActive: Bool = false) {
        self.type = type
        self.isActive = isActive
        self.selectedItemTintColor = selectedItemTintColor
        self.unselectedItemTintColor = unselectedItemTintColor

        switch type {
        case .cards:
            self.activeImage = "list.bullet.below.rectangle"
            self.inactiveImage = "list.bullet.below.rectangle"
        case .info:
            self.activeImage = "info.circle.fill"
            self.inactiveImage = "info.circle"
        case .bookmark:
            self.activeImage = "bookmark.fill"
            self.inactiveImage = "bookmark"
        case .settings:
            self.activeImage = "gear"
            self.inactiveImage = "gear"
        case .friends:
            self.activeImage = "person.2.fill"
            self.inactiveImage = "person.2"
        }
    }
}
