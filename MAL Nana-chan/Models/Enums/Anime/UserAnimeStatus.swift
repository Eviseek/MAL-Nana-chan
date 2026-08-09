//
//  UserAnimeStatus.swift
//  MAL Nana-chan
//

import Foundation

/// Where an anime sits on the signed-in user's list.
enum UserAnimeStatus: String, Codable, CaseIterable {
    case watching
    case completed
    case onHold = "on_hold"
    case dropped
    case planToWatch = "plan_to_watch"

    var displayName: String {
        switch self {
        case .watching: return "Watching"
        case .completed: return "Completed"
        case .onHold: return "On hold"
        case .dropped: return "Dropped"
        case .planToWatch: return "Plan to watch"
        }
    }

    /// The `UIView.tag` of the status button on the "my list" sheet.
    ///
    /// The sheet's five buttons are laid out in the storyboard, and the only
    /// handle the code has on them is `view.viewWithTag(_:)`. Tags start at 1
    /// because 0 is the default for *every* view, so a status mapped to 0 would
    /// match the first untagged subview it found.
    var buttonTag: Int {
        switch self {
        case .completed: return 1
        case .onHold: return 2
        case .watching: return 3
        case .dropped: return 4
        case .planToWatch: return 5
        }
    }

    init?(buttonTag: Int) {
        guard let match = Self.allCases.first(where: { $0.buttonTag == buttonTag }) else {
            return nil
        }
        self = match
    }
}
