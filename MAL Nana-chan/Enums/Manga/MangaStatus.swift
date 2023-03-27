//
//  MangaStatus.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 25.03.2023.
//

import Foundation

enum MangaStatus: String, Codable {
    
    case finished
    case currently_publishing
    case not_yet_published
    
    
    func getStatus() -> String {
        switch self {
        case .finished: return "Finished"
        case .currently_publishing: return "Currently Publishing"
        case .not_yet_published: return "Not Yet Published"
        }
    }
    
}
