//
//  AnimeStatus.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum AnimeStatus: String, Codable {
    case finished_airing = "Finished Airing"
    case currently_airing = "Currently Airing"
    case not_yet_aired = "Not Yet Aired"
}
