//
//  NetError.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import Foundation

enum NetError: Error {
    case parsing
    case decoding(error: Error)
    case server(message: String)
    case network(errorText: String)
    case connectionIsOffline

    var localizedDescription: String {
        switch self {
        case .connectionIsOffline:
            return "Проверьте подключение к сети интернет и повторите снова"
        default:
            return "Что-то пошло не так"
        }
    }

    var debugDescription: String {
        switch self {
        case .decoding(let error):
            return (error as? DecodingError).debugDescription
        default:
            return self.localizedDescription
        }
    }
}
