//
//  MediaListTarget.swift
//  MAL Nana-chan
//

import Foundation

/// What the "my list" sheets need in order to open.
struct MediaListTarget {
    let id: Int
    let kind: ItemType
    let title: String
    /// The title's own publication/airing status, not the user's.
    let statusText: String?
    /// Episodes for anime, chapters for manga.
    let unitCount: Int?
    /// Volumes. Manga only.
    let volumeCount: Int?
}

extension Anime {
    var listTarget: MediaListTarget { preview.listTarget }
}

extension Manga {
    var listTarget: MediaListTarget { preview.listTarget }
}
