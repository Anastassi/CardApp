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
    private var currentItem: IndexPath = [0, 0]

    // MARK: - initialization

    init(configuration: AutoScrollConfiguration) {
        self.configuration = configuration
    }

    // MARK: - configuration

    func setUp(colectionView: UICollectionView) {
        self.colectionView = colectionView



//        colectionView.rx
//            .itemSelected
//            .subscribe(onNext: { [weak self] (indexPath) in
//                self?.currentItem = indexPath
//            })
//            .disposed(by: self.disposeBag)

        self.startTimer()

        colectionView.rx
            .didEndDecelerating
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

    private func scrollToNext() {
        guard let collection = self.colectionView,
            let nextIndex = self.getNextItemIndexToScroll() else { return }

//        let indexPath = IndexPath(row: self.currentItem.row + 1,
//                                  section: self.currentItem.section)
//        collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        self.currentItem = indexPath

        guard let scrollDirection = (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection else { return  }
        switch scrollDirection {
        case .horizontal:
            DispatchQueue.main.async {
                collection.scrollToItem(at: nextIndex, at: .left, animated: true)
            }
        case .vertical:
            DispatchQueue.main.async {
                collection.scrollToItem(at: nextIndex, at: .top, animated: true)
            }
        @unknown default:
            return
        }

    }

    private func getNextItemIndexToScroll() -> IndexPath? {
        guard let collection = self.colectionView else { return nil }

        if let lastCell = getLastVisibleCell(),
            let lastIndex = collection.indexPath(for: lastCell) {
            if lastIndex.row == (collection.numberOfItems(inSection: 0) - 1) && collection.bounds.contains(lastCell.frame) {
                return IndexPath(item: 0, section: 0)
            }
        }

        if let partialVisibleCell = checkForPartialVisibleCells() {
            return collection.indexPath(for: partialVisibleCell)
        } else {
            guard let firstVisibleCell = getFirstVisbleCell(),
                let firstVisibleIndex = collection.indexPath(for: firstVisibleCell) else { return nil }
            let nextItem = (firstVisibleIndex.item + (collection.visibleCells.count)) % collection.numberOfItems(inSection: 0)
            return IndexPath(item: nextItem, section: 0)
        }
    }

    private func getFirstVisbleCell() -> UICollectionViewCell? {
        guard let collection = self.colectionView else { return nil }

        guard let scrollDirection = (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection else { return nil }
        switch scrollDirection {
        case .horizontal:
            let temp = collection.visibleCells.sorted(by: { $0.frame.minX < $1.frame.minX })
            let firstRowCells =  temp.filter{ $0.frame.minX == temp[0].frame.minX }
            return firstRowCells.sorted(by: { $0.frame.minY > $1.frame.minY }).first
        case .vertical:
            let temp = collection.visibleCells.sorted(by: { $0.frame.minY < $1.frame.minY })
            let firstRowCells =  temp.filter{ $0.frame.minY == temp[0].frame.minY }
            return firstRowCells.sorted(by: { $0.frame.minX < $1.frame.minX }).first
        @unknown default:
            return nil
        }
    }

    private func getLastVisibleCell() -> UICollectionViewCell? {
        guard let collection = self.colectionView,
            let scrollDirection = (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection else { return nil }
        switch scrollDirection {
        case .horizontal:
            let temp = collection.visibleCells.sorted(by: {$0.frame.maxX > $1.frame.maxX})
            let lastColumnsCells =  temp.filter{$0.frame.maxX == temp[0].frame.maxX}
            return lastColumnsCells.sorted(by: {$0.frame.minY > $1.frame.minY}).first
        case .vertical:
            let temp = collection.visibleCells.sorted(by: {$0.frame.maxY > $1.frame.maxY})
            let lastRowCells =  temp.filter{$0.frame.maxY == temp[0].frame.maxY}
            return lastRowCells.sorted(by: {$0.frame.maxX > $1.frame.maxX}).first
        @unknown default:
            return nil
        }
    }

    private func checkForPartialVisibleCells() -> UICollectionViewCell? {
        guard let collection = self.colectionView else { return nil }

        var partiallyVisibleCell: UICollectionViewCell?
        for cell in collection.visibleCells {
            if !collection.bounds.contains(cell.frame) {
                partiallyVisibleCell = cell
                break
            }
        }
        return partiallyVisibleCell
    }
}
