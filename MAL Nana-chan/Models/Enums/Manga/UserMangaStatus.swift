//
//  UserMangaStatus.swift
//  MAL Nana-chan
//

import Foundation

/// Where a manga sits on the signed-in user's list.
///
/// See `UserAnimeStatus` for why this deliberately isn't an `APIEnum` and why
/// the button tags start at 1.
enum UserMangaStatus: String, Codable, CaseIterable {
    case reading
    case completed
    case onHold = "on_hold"
    case dropped
    case planToRead = "plan_to_read"

    var displayName: String {
        switch self {
        case .reading: return "Reading"
        case .completed: return "Completed"
        case .onHold: return "On hold"
        case .dropped: return "Dropped"
        case .planToRead: return "Plan to read"
        }
    }

    var buttonTag: Int {
        switch self {
        case .completed: return 1
        case .onHold: return 2
        case .reading: return 3
        case .dropped: return 4
        case .planToRead: return 5
        }
    }

    init?(buttonTag: Int) {
        guard let match = Self.allCases.first(where: { $0.buttonTag == buttonTag }) else {
            return nil
        }
        self = match
    }
}
