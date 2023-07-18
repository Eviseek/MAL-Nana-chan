//
//  User.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 17.07.2023.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let picture: String?
    let gender: String?
    let birthday: String?
    let joinedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case picture = "picture"
        case gender = "gender"
        case birthday = "birthday"
        case joinedAt = "joined_at"
    }
    
}
