//
//  UserAnimeStatus.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum UserAnimeStatus: String, Codable {
    case watching = "watching"
    case completed = "completed"
    case onHold = "on_hold"
    case dropped = "dropped"
    case planToWatch = "plan_to_watch"
    
    func getStringValue() -> String {
        switch self {
        case .watching: return "Watching"
        case .completed: return "Completed"
        case .onHold: return "On hold"
        case .dropped: return "Dropped"
        case .planToWatch: return "Plan to watch"
        }
    }
    
}

struct UserAnimeStatusManager {
    
    func getStatusForTag(_ tag: Int) -> UserAnimeStatus {
        switch tag {
        case 1: return .completed
        case 2: return .onHold
        case 3: return .watching
        case 4: return .dropped
        case 5: return .planToWatch
        default: return .planToWatch
        }
    }
    
    func getTagForStatus(_ status: UserAnimeStatus) -> Int {
        switch status {
        case .completed: return 1
        case .onHold: return 2
        case .watching: return 3
        case .dropped: return 4
        case .planToWatch: return 5
        }
    }
    
}
