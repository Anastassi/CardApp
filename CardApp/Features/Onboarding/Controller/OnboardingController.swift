//
//  OnboardingController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import UIKit

class OnboardingController: BaseViewController {

    private let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)

    // MARK: - gui variables

    private lazy var continueButton: BaseButton = {
        let button = BaseButton()
        button.title = "Continue"
        button.action = { [weak self] in
            self?.continueButtonTapped()
        }

        return button
    }()

    // MARK: - initialization

    override func initController() {
        super.initController()

        self.showTabBar = false
        self.showNavBar = false

        self.mainView.addSubview(self.continueButton)

        self.continueButton.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview().inset(self.edgeInsets)
        }
    }

    // MARK: - actions

    private func continueButtonTapped() {
        DefaultsManager.didPassOnboarding = true
        Interface.sh.setVC(MainTabBarController())
    }
}
