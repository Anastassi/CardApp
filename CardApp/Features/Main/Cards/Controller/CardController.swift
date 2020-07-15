//
//  CardController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import InfiniteLayout

class CardController: BaseViewController {

    // MARK: - variables

    private var ringtones: [Ringtone] = []

    private let leftCellOffset: CGFloat = 20

    private let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width * 0.8,
                                          height: UIScreen.main.bounds.size.height * 0.4)

    // MARK: - gui variables

    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        return layout
    }()

    private lazy var collectionView: InfiniteCollectionView = {
        let view =  InfiniteCollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionLayout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isItemPagingEnabled = true

        view.delegate = self
        view.dataSource = self

        view.register(CardCollectionCell.self,
                      forCellWithReuseIdentifier: CardCollectionCell.identifier)

        return view
    }()

    // MARK: - initialization

    override func initController() {
        super.initController()

        self.controllerTitle = "Cards"

        self.mainView.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - life cycle

    override func singleDidAppear() {
        super.singleDidAppear()

        self.requestRingtones()
    }

    // MARK: - request

    private func requestRingtones() {
        Net.sh.request(
            urlPath: NetUrlPath.topRingtones,
            okHandler: { (ringtones: [Ringtone]) in
                self.ringtones = ringtones
                self.collectionView.reloadData()
        }, errorHandler: { error in
            print(error.debugDescription)
        })
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CardController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ringtones.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionCell.identifier,
                                                      for: indexPath)
        if let cell = cell as? CardCollectionCell,
            let model = self.ringtones.get(by: self.collectionView.indexPath(from: indexPath).row) {
            cell.set(model: model)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CardController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.leftCellOffset, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.leftCellOffset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize
    }
}
