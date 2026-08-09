//
//  MediaMetadata.swift
//  MAL Nana-chan
//

import Foundation

/// Small value types that both `Anime` and `Manga` embed.

/// Poster art. `medium` is always present; `large` often isn't.
struct Picture: Codable, Sendable {
    let large: String?
    let medium: String
}

struct AlternativeTitles: Codable, Sendable {
    let synonyms: [String]?
    let en: String?
    let ja: String?
}

struct Genre: Codable, Sendable {
    let id: Int
    let name: String
}

struct StartSeason: Codable, Sendable {
    let year: Int
    let season: Season

    var displayName: String { "\(season.displayName) \(year)" }
}

struct Broadcast: Codable, Sendable {
    var dayOfTheWeek: Day
    var startTime: String?

    private enum CodingKeys: String, CodingKey {
        case dayOfTheWeek = "day_of_the_week"
        case startTime = "start_time"
    }
}

struct AnimeStudio: Codable, Sendable {
    let id: Int
    let name: String
}
