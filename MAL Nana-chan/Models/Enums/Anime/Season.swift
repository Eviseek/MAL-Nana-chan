//
//  Season.swift
//  MAL Nana-chan
//

import Foundation

/// An anime broadcast season.
enum Season: String, Codable, CaseIterable {
    case winter
    case spring
    case summer
    case fall

    var displayName: String {
        switch self {
        case .winter: return "Winter"
        case .spring: return "Spring"
        case .summer: return "Summer"
        case .fall: return "Fall"
        }
    }

    /// The season a calendar month falls in. Months outside 1...12 can't occur
    /// from `Calendar`, so they fold into winter rather than being an error.
    init(month: Int) {
        switch month {
        case 1, 2, 3: self = .winter
        case 4, 5, 6: self = .spring
        case 7, 8, 9: self = .summer
        case 10, 11, 12: self = .fall
        default: self = .winter
        }
    }

    /// The season after this one, and whether it falls in the next calendar
    /// year — winter rolls over, the other three don't.
    var next: (season: Season, isNextYear: Bool) {
        switch self {
        case .winter: return (.spring, false)
        case .spring: return (.summer, false)
        case .summer: return (.fall, false)
        case .fall: return (.winter, true)
        }
    }

    /// The season we are in right now.
    static var current: Season {
        Season(month: Calendar.current.component(.month, from: Date()))
    }

    /// The season after the current one, with the year it belongs to.
    static var upcoming: (season: Season, year: Int) {
        let year = Calendar.current.component(.year, from: Date())
        let next = current.next
        return (next.season, next.isNextYear ? year + 1 : year)
    }

    static var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
}
