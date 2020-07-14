//
//  Ringtone.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import Foundation

class Ringtone: Decodable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "ringtone_id"
        case title, description
        case imageUrl = "image_aws_url"
    }
}
