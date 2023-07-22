//
//  Token.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 18.07.2023.
//

import Foundation

struct Token: Decodable {
    let tokenType: String
    let expiresIn: Int
    let accessToken: String
    let refreshToken: String
    
    private enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
