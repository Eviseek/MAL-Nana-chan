//
//  UserMangaStatus.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.07.2023.
//

import Foundation

enum UserMangaStatus: String, Codable {
    case reading = "reading"
    case completed = "completed"
    case onHold = "on_hold"
    case dropped = "dropped"
    case planToRead = "plan_to_read"

    func getStringValue() -> String {
        switch self {
        case .reading: return "Reading"
        case .completed: return "Completed"
        case .onHold: return "On hold"
        case .dropped: return "Dropped"
        case .planToRead: return "Plan to read"
        }
    }

}

struct UserMangaStatusManager {

func getStatusForTag(_ tag: Int) -> UserMangaStatus {
    switch tag {
    case 1: return .completed
    case 2: return .onHold
    case 3: return .reading
    case 4: return .dropped
    case 5: return .planToRead
    default: return .planToRead
    }
}

func getTagForStatus(_ status: UserMangaStatus) -> Int {
    switch status {
    case .completed: return 1
    case .onHold: return 2
    case .reading: return 3
    case .dropped: return 4
    case .planToRead: return 5
    }
}
    
    
}
