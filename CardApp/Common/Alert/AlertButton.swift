//
//  AlertButton.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import UIKit

typealias AlertButtonHandler = ((UIAlertAction) -> Void)

class AlertButton {
    let title: String
    let style: UIAlertAction.Style
    let handler: AlertButtonHandler?

    init(title: String,
         style: UIAlertAction.Style,
         handler: AlertButtonHandler? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
