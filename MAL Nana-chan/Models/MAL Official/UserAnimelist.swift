//
//  UserAnimelist.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.07.2023.
//

import Foundation

struct UserAnimelist: Codable {
    var data: [AnimelistData]
    var paging: Paging?
}

struct AnimelistData: Codable {
    let node: Anime
    let list_status: MyListStatus
}
