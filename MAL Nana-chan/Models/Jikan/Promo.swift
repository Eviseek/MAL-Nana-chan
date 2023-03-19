//
//  Promo.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation

struct Promo: Codable {
    let pagination: Pagination?
    let data: [PromoData]
}

struct PromoData: Codable {
    //let entry
    let title: String
    let trailer: Trailer?
}

struct Trailer: Codable {
    let youtube_id: String?
    let url: String?
    let embed_url: String?
}

struct Pagination: Codable {
    let last_visible_page: Int?
    let has_next_page: Bool?
}
