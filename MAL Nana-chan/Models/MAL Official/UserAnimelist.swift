//
//  UserAnimelist.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.07.2023.
//

import Foundation

struct UserAnimelist: Codable {
    let data: [AnimelistData]
    let paging: Paging?
}

struct AnimelistData: Codable {
    let node: Anime
    let list_status: MyListStatus
}
