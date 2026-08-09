//
//  JikanResponse.swift
//  MAL Nana-chan
//

import Foundation

/// Jikan wraps every payload in `{ "data": …, "pagination": … }`.
///
/// One generic envelope replaces the five near-identical wrapper structs the old
/// code had (`Recommendation`, `Theme`, `AnimeMoreInformation`,
/// `MangaMoreInformation`, `Promo`), each of which existed only to hold a `data`
/// property.
struct JikanResponse<Value: Codable & Sendable>: Codable, Sendable {
    let data: Value?
    let pagination: JikanPagination?
}

struct JikanPagination: Codable, Sendable {
    let lastVisiblePage: Int?
    let hasNextPage: Bool?

    private enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
    }
}
