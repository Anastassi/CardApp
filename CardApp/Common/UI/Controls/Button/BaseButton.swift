//
//  BaseButton.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import UIKit

class BaseButton: UIButton {

    //MARK: - public properties

    var edgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }

    var title: String = "" {
        didSet {
            self.setTitle(title, for: UIControl.State())
        }
    }

    var buttonColor: UIColor = .systemTeal {
        didSet {
            self.contentView.backgroundColor = buttonColor
        }
    }

    var cornerRadius: CGFloat = 15 {
        didSet {
            self.contentView.layer.cornerRadius = self.cornerRadius
        }
    }

    var action: (() -> Void)?

    //MARK: - gui variables

    private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false

        return view
    }()

    //MARK: - initialization

    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.contentView)
        self.addTarget(self, action: #selector(self.tapAction), for: .touchUpInside)
        self.setAppearance()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - constraints

    override func updateConstraints() {
        self.contentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.edgeInsets)
            make.height.equalTo(self.intrinsicContentSize)
        }

        super.updateConstraints()
    }

    //MARK: - appearance

    func setAppearance() {
        self.contentEdgeInsets = UIEdgeInsets(top: 17, left: 10, bottom: 17, right: 10)
        self.contentView.backgroundColor = self.buttonColor
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = cornerRadius
        self.titleLabel?.font = .systemFont(ofSize: 17)
    }

    // MARK: - action

    @objc private func tapAction() {
        self.action?()
    }
}
