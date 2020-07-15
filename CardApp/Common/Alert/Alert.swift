//
//  Alert.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import UIKit

class Alert {
    class func showAlert(title: String? = nil,
                         message: String?,
                         buttons: AlertButton...,
                         animated: Bool = true) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        buttons.forEach {
            alert.addAction(UIAlertAction(title: $0.title,
                                          style: $0.style,
                                          handler: $0.handler))
        }

        Interface.sh.topController?.present(alert,
                                            animated: animated,
                                            completion: nil)
    }

    class func showError(error: NetError, animated: Bool = true) {
        let alert = UIAlertController(title: "",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))

        Interface.sh.topController?.present(alert,
                                            animated: animated,
                                            completion: nil)
    }
}
