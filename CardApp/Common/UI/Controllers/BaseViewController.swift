//
//  BaseViewController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - variables

    var showTabBar: Bool = true

    var controllerTitle: String? {
        get {
            self.navigationItem.title
        }
        set {
            self.navigationItem.title = newValue
            self.navigationController?.navigationBar.backItem?.title = " "
        }
    }

    // MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self._initController()
        self.initController()
    }

    // MARK: - initialization

    private func _initController() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.view.backgroundColor = .white
    }

    func initController() {}
}
