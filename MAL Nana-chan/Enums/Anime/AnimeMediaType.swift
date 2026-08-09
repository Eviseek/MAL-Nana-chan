//
//  AnimeMediaType.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum AnimeMediaType: String, APIEnum {

    case unknown
    case tv
    case ova
    case movie
    case special
    case ona
    case music
    // Returned by the live API but missing from MAL's published documentation.
    case tv_special
    case pv
    case cm

    static let unknownValue = AnimeMediaType.unknown

    func getType() -> String {
        switch self {
        case .unknown: return "Unknown"
        case .tv: return "TV series"
        case .ova: return "OVA"
        case .movie: return "Movie"
        case .special: return "Special"
        case .ona: return "ONA"
        case .music: return "Music"
        case .tv_special: return "TV Special"
        case .pv: return "PV"
        case .cm: return "Commercial"
        }
    }

}
