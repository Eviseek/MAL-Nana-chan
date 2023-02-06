//
//  URLs.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 05.02.2023.
//

import UIKit

enum URLs: String {
    //GET urls
    case animeURL = "https://api.myanimelist.net/v2/anime/{id}"
    case animelistURL = "https://api.myanimelist.net/v2/anime"
    case animeSeasonalURL = "https://api.myanimelist.net/v2/anime/season"
    case animeSuggestionsURL = "https://api.myanimelist.net/v2/anime/suggestions"
    
    case animeURLAll = "https://api.myanimelist.net/v2/anime/{id}?fields=synopsis,mean,status,num_episodes,start_season,media_type,average_episode_duration"
    
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

extension String {
    
    func getURLWithId(_ id: Int) -> String {
        if self.contains("{id}") {
            return self.replacingOccurrences(of: "{id}", with: id.description)
            print("returned url \(self.replacingOccurrences(of: "{id}", with: id.description))")
        }
        return self
    }
    
}
