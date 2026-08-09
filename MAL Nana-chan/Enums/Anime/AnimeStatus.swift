//
//  AnimeStatus.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum AnimeStatus: String, APIEnum {

    case unknown
    case finished_airing
    case currently_airing
    case not_yet_aired

    static let unknownValue = AnimeStatus.unknown
    
    func getStatus() -> String {
        switch self {
        case .unknown: return "Unknown"
        case .finished_airing: return "Finished Airing"
        case .currently_airing: return "Currently Airing"
        case .not_yet_aired: return "Not Yet Aired"
        }
    }
}
