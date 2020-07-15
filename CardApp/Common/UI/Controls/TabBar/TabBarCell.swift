//
//  TabBarCell.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit
import SnapKit

class TabBarCell: UICollectionViewCell {

    static let identifier = "TabBarCell"

    private let selectionDuration: Double = 0.3

    // MARK: - gui variables

    private let edgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)

    private lazy var selectedImageView = UIImageView()
    private lazy var deselectedImageView = UIImageView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center

        return label
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup

    private func setupViews() {
        self.selectedImageView.alpha = 0

        self.contentView.addSubview(self.deselectedImageView)
        self.contentView.addSubview(self.selectedImageView)
        self.contentView.addSubview(self.titleLabel)

        self.makeConstraints()
    }

    func makeConstraints() {
        self.deselectedImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
        }

        self.selectedImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.deselectedImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(self.edgeInsets)
        }
    }

    // MARK: - setters

    func set(model: AMTabBarCellModel) {
        var deselectedImage = UIImage(systemName: model.inactiveImage)
        if let uselectedItemTintColor = model.unselectedItemTintColor {
            deselectedImage = deselectedImage?.withTintColor(uselectedItemTintColor,
                                                             renderingMode: .alwaysOriginal)
        }
        self.deselectedImageView.image = deselectedImage
        self.selectedImageView.image = UIImage(systemName: model.activeImage)?.withTintColor(model.selectedItemTintColor,
                                                                                             renderingMode: .alwaysOriginal)
        self.titleLabel.text = model.type.title
    }

    // MARK: - update

    func update(animated: Bool) {
        let selectionBlock = {
            self.selectedImageView.alpha = self.isSelected ? 1 : 0
            self.deselectedImageView.alpha = self.isSelected ? 0 : 1
        }

        animated
            ? UIView.animate(withDuration: self.selectionDuration) { selectionBlock() }
            : selectionBlock()
    }
}
