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

struct UserAnimeStatusManager {
    
    func getStatusForTag(_ tag: Int) -> UserAnimeStatus {
        switch tag {
        case 1: return .completed
        case 2: return .on_hold
        case 3: return .watching
        case 4: return .dropped
        case 5: return .plan_to_watch
        default: return .plan_to_watch
        }
    }
    
}
