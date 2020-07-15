//
//  BaseViewController.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit
import SnapKit
import RxSwift

class BaseViewController: UIViewController {

    // MARK: - variables

    var showTabBar: Bool = true {
        didSet {
            self.mainViewBottomConstraint?.update(offset:
                self.showTabBar
                    ? -(Interface.sh.navController.tabBarInsets.bottom
                        + Interface.sh.tabBar.tabBarHeight)
                    : 0)
        }
    }

    var showNavBar: Bool = true

    var controllerTitle: String? {
        get {
            self.navigationItem.title
        }
        set {
            self.navigationItem.title = newValue
            self.navigationController?.navigationBar.backItem?.title = " "
        }
    }

    let disposeBag = DisposeBag()

    // MARK: - life cycle variables

    private(set) var isViewDidAppeared: Bool = false

    // MARK: - gui variables

    private var mainViewBottomConstraint: Constraint?
    private(set) lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }()

    // MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self._initController()
        self.initController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.navigationBar.isHidden = !self.showNavBar

        if !self.isViewDidAppeared {
            self.isViewDidAppeared = true
            self.singleDidAppear()
        }

        if self.parent is UINavigationController {
            self.showTabBar ? Interface.sh.navController.showTabBar() : Interface.sh.navController.hideTabBar()
        }
    }

    func singleDidAppear() {}

    // MARK: - initialization

    private func _initController() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.view.backgroundColor = .white

        self.view.addSubview(self.mainView)
        
        self.mainView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            self.mainViewBottomConstraint = make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).constraint
        }

        self.mainViewBottomConstraint?.update(offset:
            self.showTabBar
                ? -(Interface.sh.navController.tabBarInsets.bottom + Interface.sh.tabBar.tabBarHeight)
                : 0)
    }

    func initController() {}
}
