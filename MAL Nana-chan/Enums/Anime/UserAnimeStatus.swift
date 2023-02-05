//
//  UserAnimeStatus.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum UserAnimeStatus: String, Codable {
    case watching = "Watching"
    case completed = "Completed"
    case on_hold = "On hold"
    case dropped = "Dropped"
    case plan_to_watch = "Plan to watch"
}
