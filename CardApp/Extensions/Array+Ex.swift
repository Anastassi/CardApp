//
//  Array+Ex.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/14/20.
//

import Foundation

extension Array {
    func get(by index: Int) -> Element? {
        if index < 0 || index >= count {
            return nil
        } else {
            return self[index]
        }
    }
}
