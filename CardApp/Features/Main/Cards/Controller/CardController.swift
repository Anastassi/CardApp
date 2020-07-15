//
//  CardController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import InfiniteLayout
import RxSwift
import RxCocoa
import RxDataSources

class CardController: BaseViewController {

    // MARK: - variables

    private var ringtones: BehaviorRelay<[Ringtone]> = BehaviorRelay(value: [])

    private let leftCellOffset: CGFloat = 20

    private let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width * 0.8,
                                          height: UIScreen.main.bounds.size.height * 0.4)

    private lazy var autoScroll = AutoScroll(configuration: AutoScrollConfiguration(interval: 2, scrollDirection: .right))

    // MARK: - gui variables

    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        return layout
    }()

    private lazy var collectionView: RxInfiniteCollectionView = {
        let view = RxInfiniteCollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionLayout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isItemPagingEnabled = true

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

        self.setupCollection()
    }

    // MARK: - life cycle

    override func singleDidAppear() {
        super.singleDidAppear()

        self.requestRingtones()
    }

    // MARK: - setup

    private func setupCollection() {
        self.ringtones
            .bind(to: self.collectionView.rx.items(cellIdentifier: CardCollectionCell.identifier,
                                                   cellType: CardCollectionCell.self,
                                                   infinite: true)) { row, element, cell in
                                                    cell.set(model: element) }
            .disposed(by: self.disposeBag)

        self.collectionView.rx
            .modelSelected(Ringtone.self)
            .subscribe(onNext: { (ringtone) in
                Alert.showAlert(message: ringtone.title,
                                buttons: AlertButton(title: "Close", style: .default))
            }).disposed(by: self.disposeBag)

        self.autoScroll.setUp(colectionView: self.collectionView)
    }

    // MARK: - request

    private func requestRingtones() {
        Net.sh.request(
            urlPath: NetUrlPath.topRingtones,
            okHandler: { [weak self] (ringtones: [Ringtone]) in
                guard let self = self else { return }
                self.ringtones.accept(ringtones)
        }, errorHandler: { error in
            Alert.showError(error: error)
        })
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
