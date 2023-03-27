//
//  MediaType.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum AnimeMediaType: String, Codable {
    case unknown
    case tv
    case ova
    case movie
    case special
    case ona
    case music
    
    func getType() -> String {
        switch self {
        case .unknown: return "Unknown"
        case .tv: return "TV series"
        case .ova: return "OVA"
        case .movie: return "Movie"
        case .special: return "Special"
        case .ona: return "ONA"
        case .music: return "Music"
        }
    }
}
