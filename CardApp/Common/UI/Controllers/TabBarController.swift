//
//  TabBarController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

class TabBarController: UINavigationController {

    private let tabBarAnimationDuration: Double = 0.3
    private var isTabBarAnimating: Bool = false

    // MARK: - gui variables

    private(set) var tabBarInsets = UIEdgeInsets(top: 0, left: 20, bottom: 24, right: 20)

    private(set) lazy var tabBarView: TabBarView = {
        let view = TabBarView()
//        view.isHidden = true

        return view
    }()

    // MARK: - life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.view.addSubview(self.tabBarView)
        self.tabBarView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview().inset(self.tabBarInsets)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(self.tabBarInsets)
        }
    }

    // MARK: - tabBar

    func showTabBar() {
        guard self.tabBarView.isHidden, !self.isTabBarAnimating else { return }

        self.isTabBarAnimating = true
        self.tabBarView.isHidden = false
        self.tabBarView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(self.tabBarInsets)
        }

        UIView.animate(withDuration: self.tabBarAnimationDuration, animations: {
            self.tabBarView.alpha = 1
            self.tabBarView.superview?.layoutIfNeeded()
        }) { (_) in
            self.isTabBarAnimating = false
        }
    }

    func hideTabBar() {
        guard !self.tabBarView.isHidden, !self.isTabBarAnimating else { return }

        self.isTabBarAnimating = true
        self.tabBarView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
            make.left.right.equalToSuperview().inset(self.tabBarInsets)
        }

        UIView.animate(withDuration: self.tabBarAnimationDuration, animations: {
            self.tabBarView.alpha = 0
            self.tabBarView.superview?.layoutIfNeeded()
        }) { (_) in
            self.tabBarView.isHidden = true
            self.isTabBarAnimating = false
        }
    }

    @discardableResult
    func popToRoot(animated: Bool) -> [UIViewController]? {
        if let tabVC = self.viewControllers.first(where: { $0 is MainTabBarController }) as? MainTabBarController,
            let navController = tabVC.selectedViewController as? UINavigationController {
            return navController.popToRootViewController(animated: animated)
        } else {
            return super.popToRootViewController(animated: animated)
        }
    }

    /// Sets controllers directly to `viewControllers` avoiding tabBarController check
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool, forced: Bool) {
        if forced {
            super.setViewControllers(viewControllers, animated: true)
        } else {
            self.setViewControllers(viewControllers, animated: animated)
        }
    }
}
