//
//  MangaMediaType.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 25.03.2023.
//

import Foundation

enum MangaMediaType: String, Codable {
    case unknown
    case manga
    case novel
    case one_shot
    case doujinshi
    case manhwa
    case manhua
    case oel
    case light_novel
    
    
    func getType() -> String {
        switch self {
        case .unknown: return "Unknown type"
        case .manga: return "Manga"
        case .novel: return "Novel"
        case .one_shot: return "One shot"
        case .doujinshi: return "Doujinshi"
        case .manhwa: return "Manhwa"
        case .manhua: return "Manhua"
        case .oel: return "OEL"
        case .light_novel: return "Light Novel"
        }
    }
    
}
