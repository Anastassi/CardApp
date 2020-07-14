//
//  DefaultsManager.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

struct DefaultsManager {
    @UserDefault(.didPassOnboarding, defaultValue: false)
    static var didPassOnboarding: Bool
}
