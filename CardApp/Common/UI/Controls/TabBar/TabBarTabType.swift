//
//  TabBarTabType.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

enum TabBarTabType: Int {
    case cards
    case info
    case bookmark
    case settings
    case friends

    var title: String {
        switch self {
        case .cards:
            return "Cards"
        case .info:
            return "Info"
        case .bookmark:
            return "Bookmark"
        case .settings:
            return "Settings"
        case .friends:
            return "Friends"
        }
    }
}
