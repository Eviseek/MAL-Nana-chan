//
//  Rating.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

/// The raw values here are MAL's `Value` column, not its `Description` column.
/// The API sends `"pg_13"`, never `"Teens 13 and Older"` — use `getRating()`
/// when you need something to show the user.
enum Rating: String, APIEnum {

    case unknown
    case g
    case pg
    case pg_13
    case r
    case r_plus = "r+"
    case rx

    static let unknownValue = Rating.unknown

    func getRating() -> String {
        switch self {
        case .unknown: return "Unknown"
        case .g: return "G - All Ages"
        case .pg: return "PG - Children"
        case .pg_13: return "PG-13 - Teens 13 and Older"
        case .r: return "R - 17+ (violence & profanity)"
        case .r_plus: return "R+ - Profanity & Mild Nudity"
        case .rx: return "Rx - Hentai"
        }
    }

}
