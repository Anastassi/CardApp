//
//  CardController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

class CardController: BaseViewController {

    // MARK: - variables

    private var ringtones: [Ringtone] = []

    // MARK: - initialization

    override func initController() {
        super.initController()

        self.controllerTitle = "Cards"
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
            reqModel: nil,
            okHandler: { (ringtones: [Ringtone]) in
                print(ringtones)
                self.ringtones = ringtones
        }, errorHandler: { error in
            print(error.debugDescription)
        })
    }
}
