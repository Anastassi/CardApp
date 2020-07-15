//
//  BaseView.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

class BaseView: UIView {

    // MARK: - initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initView()
    }

    init() {
        super.init(frame: CGRect.zero)

        self.initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() {}
}
