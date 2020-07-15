//
//  InfoController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

class InfoController: BaseViewController {

     private let edgeInsets = UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)

    // MARK: - gui variables

    private lazy var selectedTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        label.text = "Selected Item Title"

        return label
    }()

    override func initController() {
        super.initController()

        self.controllerTitle = "Info"

        self.mainView.addSubview(self.selectedTitle)

        self.selectedTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.centerY.equalTo(self.view.snp.centerY)
        }
    }
}
