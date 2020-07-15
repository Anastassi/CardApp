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

    let viewModel: CardCollectionViewModel

    private let leftCellOffset: CGFloat = 20

    private let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width * 0.8,
                                          height: UIScreen.main.bounds.size.height * 0.4)

    private lazy var autoScroll = AutoScroll(configuration: AutoScrollConfiguration(interval: 2, scrollDirection: .right))

    // MARK: - gui variables

    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: self.leftCellOffset, bottom: 0, right: 0)
        layout.minimumLineSpacing = self.leftCellOffset
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.cellSize

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

    init(viewModel: CardCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initController() {
        super.initController()

        self.controllerTitle = "Cards"

        self.mainView.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        self.bindViewsToViewModel()
    }

    // MARK: - life cycle

    override func singleDidAppear() {
        super.singleDidAppear()

        self.requestRingtones()
    }

    // MARK: - setup

    private func bindViewsToViewModel() {
        self.viewModel.ringtones
            .bind(to: self.collectionView.rx.items(cellIdentifier: CardCollectionCell.identifier,
                                                   cellType: CardCollectionCell.self,
                                                   infinite: true)) { row, element, cell in
                                                    cell.set(model: element) }
            .disposed(by: self.disposeBag)

        self.collectionView.rx
            .modelSelected(Ringtone.self)
            .subscribe(onNext: { [weak self] (ringtone) in
                self?.viewModel.set(selectedRingtone: ringtone)
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
                self.viewModel.set(ringtones: ringtones)
        }, errorHandler: { error in
            Alert.showError(error: error)
        })
    }
}
