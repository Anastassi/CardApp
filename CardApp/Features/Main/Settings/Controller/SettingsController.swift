//
//  SettingsController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

class SettingsController: BaseViewController {

    private let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)

    // MARK: - gui variables

    private lazy var resetOnboardingButton: BaseButton = {
        let button = BaseButton()
        button.title = "Reset onboarding"
        button.action = { [weak self] in
            self?.resetButtonTapped()
        }

        return button
    }()

    // MARK: - initialization

    override func initController() {
        super.initController()

        self.controllerTitle = "Settings"

        self.mainView.addSubview(self.resetOnboardingButton)

        self.resetOnboardingButton.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview().inset(self.edgeInsets)
        }
    }

    // MARK: - actions

    private func resetButtonTapped() {
        DefaultsManager.didPassOnboarding = false
    }
}
