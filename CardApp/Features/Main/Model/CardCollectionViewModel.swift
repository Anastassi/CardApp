//
//  CardCollectionViewModel.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import Foundation
import RxSwift
import RxCocoa

class CardCollectionViewModel {
    private(set) var ringtones: BehaviorRelay<[Ringtone]> = BehaviorRelay(value: [])

    var selectedRingtone: BehaviorSubject<Ringtone?> = BehaviorSubject(value: nil)

    func set(ringtones: [Ringtone]) {
        self.ringtones.accept(ringtones)
    }

    func set(selectedRingtone: Ringtone) {
        self.selectedRingtone.onNext(selectedRingtone)
    }
}
