//
//  ItemType.swift
//  MAL Nana-chan
//

import Foundation

/// Anime or manga.
///
/// Small, but load-bearing: it decides which detail screen a tap opens and which
/// service a list request goes to.
enum ItemType: Codable, Hashable {
    case anime
    case manga
}
