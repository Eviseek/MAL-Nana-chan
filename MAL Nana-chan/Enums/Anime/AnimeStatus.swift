//
//  AnimeStatus.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum AnimeStatus: String, Codable {
    case finished_airing
    case currently_airing
    case not_yet_aired 
    
    func getStatus() -> String {
        switch self {
        case .finished_airing: return "Finished Airing"
        case .currently_airing: return "Currently Airing"
        case .not_yet_aired: return "Not Yet Aired"
        }
    }
}
