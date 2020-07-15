//
//  UIView+Ex.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import UIKit

extension UIView {
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }

    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
}
