//
//  URLs.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 05.02.2023.
//

import Foundation

enum URLs: String {
    //GET urls
    case animeURL = "https://api.myanimelist.net/v2/anime/"
    case animelistURL = "https://api.myanimelist.net/v2/anime"
    case animeSeasonalURL = "https://api.myanimelist.net/v2/anime/season"
    case animeSuggestionsURL = "https://api.myanimelist.net/v2/anime/suggestions"
    
//    func get(_ id: String?, _ season: Season?, _ year: String?) -> String {
//        switch self {
//        case .animeURL: return "\(URLs.animeURL.rawValue)/\(id)"
//        case .animelistURL: return URLs.animelistURL.rawValue
//        case .animeSeasonalURL: return "\(URLs.animeSeasonalURL)/\(year)/\(season?.rawValue)"
//        case .animeSuggestionsURL: return URLs.animeSuggestionsURL.rawValue
//        default: return ""
//        }
//    }

    
}
