//
//  Priority.swift
//  MAL Nana-chan
//

import Foundation

/// How urgently the user wants to get to a title. Part of `my_list_status`.
enum Priority: Int, Codable, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2

    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
}
