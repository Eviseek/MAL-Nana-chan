//
//  JikanDetails.swift
//  MAL Nana-chan
//

import Foundation

/// `/anime/{id}/full` — the production credits MAL's own API doesn't expose,
/// plus the theme songs.
struct AnimeDetails: Codable, Sendable {
    let producers: [JikanEntity]?
    let licensors: [JikanEntity]?
    let studios: [JikanEntity]?
    let theme: ThemeSongs?
}

/// `/manga/{id}/full`.
struct MangaDetails: Codable, Sendable {
    let authors: [JikanEntity]?
    let serializations: [JikanEntity]?
    let demographics: [JikanEntity]?
}

/// A named thing on MAL's website — studio, producer, author, magazine.
/// `url` points at its MAL page, which the More Information screens link to.
struct JikanEntity: Codable, Sendable {
    let name: String
    let url: String
}

/// Opening and ending themes, as free-form credit lines.
struct ThemeSongs: Codable, Sendable {
    let openings: [String]?
    let endings: [String]?

    var isEmpty: Bool {
        (openings?.isEmpty ?? true) && (endings?.isEmpty ?? true)
    }
}

/// `/watch/promos` — trailer feed for the Home screen.
struct Promo: Codable, Sendable {
    let title: String
    let trailer: Trailer?
}

struct Trailer: Codable, Sendable {
    let youtubeID: String?
    let url: String?
    let embedURL: String?

    private enum CodingKeys: String, CodingKey {
        case youtubeID = "youtube_id"
        case url
        case embedURL = "embed_url"
    }
}
