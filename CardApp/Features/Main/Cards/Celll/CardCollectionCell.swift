//
//  CardCollectionCell.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import UIKit
import AlamofireImage

class CardCollectionCell: UICollectionViewCell {

    static let identifier = "CardCollectionCell"

    private let stubImageName: String = "imageStub"

    // MARK: - gui variables

    private let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .white

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
        self.contentView.addSubview(self.backgroundImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)

        self.makeConstraints()
    }

    func makeConstraints() {
        self.backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview().inset(self.edgeInsets)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }

        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            make.left.right.bottom.equalToSuperview().inset(self.edgeInsets)
        }
    }

    // MARK: - reuse

    override func prepareForReuse() {
        super.prepareForReuse()

        self.backgroundImageView.af.cancelImageRequest()
    }

    // MARK: - setters

    func set(model: Ringtone) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.description
        if let url = URL(string: model.imageUrl) {
            self.backgroundImageView
                .af
                .setImage(
                    withURL: url,
                    placeholderImage: UIImage(named: self.stubImageName),
                    filter: AspectScaledToFillSizeFilter(size: self.size),
                    imageTransition: .crossDissolve(1),
                    runImageTransitionIfCached: true)
        }
    }
}
