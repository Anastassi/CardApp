//
//  UserDefaultWrapper.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultsKey
    let defaultValue: T

    init(_ key: UserDefaultsKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
}
