//
//  AutoScroll.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import UIKit
import RxSwift
import RxCocoa

struct AutoScrollConfiguration {
    let interval: Double
    let scrollDirection: AuroScrollDirection
}

enum AuroScrollDirection {
    case left, right
}

class AutoScroll {

    // MARK: - variables

    private let configuration: AutoScrollConfiguration

    private let disposeBag = DisposeBag()

    private var timer: Timer?

    private var colectionView: UICollectionView?

    // MARK: - initialization

    init(configuration: AutoScrollConfiguration) {
        self.configuration = configuration
    }

    // MARK: - configuration

    func setUp(colectionView: UICollectionView) {
        self.colectionView = colectionView

        self.startTimer()

        colectionView.rx
            .willBeginDragging
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.stopTimer()
            })
            .disposed(by: self.disposeBag)

        colectionView.rx
            .didEndDecelerating
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.timer == nil {
                    self.startTimer()
                }
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: - timer actions

    private func startTimer() {
        let timer = Timer(timeInterval: self.configuration.interval,
                           repeats: true,
                           block: { (timer) in
                            self.scrollToNext()
        })
        RunLoop.current.add(timer, forMode: .common)

        self.timer = timer
    }

    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    // MARK: - scroll 

    private func scrollToNext() {
        guard let collection = self.colectionView,
            let currentFullIndex = self.getFullIndexPath() else { return }

        guard let scrollDirection = (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection else { return  }

        let nextRow = self.configuration.scrollDirection == .left
            ? currentFullIndex.row - 1
            : currentFullIndex.row + 1

        switch scrollDirection {
        case .horizontal:
            DispatchQueue.main.async {
                collection.scrollToItem(at: IndexPath(row: nextRow,
                                                      section: currentFullIndex.section),
                                        at: .centeredHorizontally,
                                        animated: true)
            }
        case .vertical:
            DispatchQueue.main.async {
                collection.scrollToItem(at: IndexPath(row: nextRow,
                                                      section: currentFullIndex.section),
                                        at: .centeredVertically,
                                        animated: true)
            }
        @unknown default:
            return
        }

    }

    private func getFullIndexPath() -> IndexPath? {
        guard let collection = self.colectionView else { return nil }

        let visibleIndexPaths = collection.indexPathsForVisibleItems

        for indexPath in visibleIndexPaths {
            guard let attributes = collection.layoutAttributesForItem(at: indexPath) else { continue }
            let rect = collection.convert(attributes.frame, to: collection.superview)
            if rect.minX > 0,
                rect.minY > 0,
                rect.maxY < collection.frame.maxY,
                rect.maxX < collection.frame.maxX {
                return indexPath
            }
        }

        return nil
    }
}
