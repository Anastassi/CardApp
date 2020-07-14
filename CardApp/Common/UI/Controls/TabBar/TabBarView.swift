//
//  TabBarView.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit
import SnapKit

protocol TabBarViewDelegate: class {
    func didSelectTab(type: TabBarTabType)
}

class TabBarView: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - variables

    weak var delegate: TabBarViewDelegate?

    var tabBarBackgroundColor: UIColor = .tertiarySystemBackground {
        didSet {
            self.contentView.backgroundColor = self.tabBarBackgroundColor
        }
    }
    var tabbarTintColor: UIColor = .red
    var uselectedItemTintColor: UIColor?

    let tabBarHeight: CGFloat = 56
    private let containerCornerRadius: CGFloat = 28

    // MARK: - collection parameters

    private(set) var selectedTab: TabBarTabType = .cards

    private lazy var standardBarItems = [
        AMTabBarCellModel(type: .cards,
                          selectedItemTintColor: self.tabbarTintColor,
                          unselectedItemTintColor: self.uselectedItemTintColor,
                          isActive: true),
        AMTabBarCellModel(type: .info,
                          selectedItemTintColor: self.tabbarTintColor,
                          unselectedItemTintColor: self.uselectedItemTintColor),
        AMTabBarCellModel(type: .bookmark,
                          selectedItemTintColor: self.tabbarTintColor,
                          unselectedItemTintColor: self.uselectedItemTintColor),
        AMTabBarCellModel(type: .settings,
                          selectedItemTintColor: self.tabbarTintColor,
                          unselectedItemTintColor: self.uselectedItemTintColor),
        AMTabBarCellModel(type: .friends,
                          selectedItemTintColor: self.tabbarTintColor,
                          unselectedItemTintColor: self.uselectedItemTintColor)
    ]

    // MARK: - gui variables

    private lazy var contentView: BaseView = {
        let view = BaseView()
        view.clipsToBounds = true
        view.layer.cornerRadius = self.containerCornerRadius
        view.backgroundColor = self.tabBarBackgroundColor

        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(TabBarCell.self, forCellWithReuseIdentifier: TabBarCell.identifier)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self

        return view
    }()

    // MARK: - initialization

    override func initView() {
        super.initView()

        self.layer.shadowColor = UIColor.black.cgColor.copy(alpha: 0.2)
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 14

        self.addSubview(self.contentView)
        self.contentView.addSubview(self.collectionView)
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.contentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.collectionView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(self.tabBarHeight)
        }

        super.updateConstraints()
    }

    // MARK: - actions

    /// use to select specified tab bar item
    func select(item: TabBarTabType) {
        self.selectItem(at: item.rawValue)
    }

    private func selectAction(index: Int) {
        self.selectedTab = TabBarTabType(rawValue: index) ?? .cards
        self.delegate?.didSelectTab(type: self.selectedTab)
    }

    private func selectItem(at index: Int, withAction: Bool = true) {
        let indexPathToSelect = IndexPath(item: index, section: 0)
        let indexPathToDeselect = IndexPath(item: self.selectedTab.rawValue, section: 0)
        self.collectionView.selectItem(at: indexPathToSelect, animated: false, scrollPosition: [])
        (self.collectionView.cellForItem(at: indexPathToDeselect) as? TabBarCell)?.update(animated: true)
        (self.collectionView.cellForItem(at: indexPathToSelect) as? TabBarCell)?.update(animated: true)
        self.selectAction(index: index)
    }

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.standardBarItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.identifier, for: indexPath)
        if let tabBarCell = cell as? TabBarCell,
            let item = self.standardBarItems.get(by: indexPath.item) {
            tabBarCell.set(model: item)
            if item.isActive {
                tabBarCell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                tabBarCell.update(animated: false)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? TabBarCell)?.update(animated: true)
        self.selectAction(index: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? TabBarCell)?.update(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.width / CGFloat(self.standardBarItems.count),
                      height: self.collectionView.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
