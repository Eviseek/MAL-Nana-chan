//
//  URLs.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 05.02.2023.
//

import UIKit

enum URLs: String {
    //GET MAL urls
    case animeURL = "https://api.myanimelist.net/v2/anime/{id}"
    case animelistURL = "https://api.myanimelist.net/v2/anime"
    case animeSeasonalURL = "https://api.myanimelist.net/v2/anime/season"
    case animeSuggestionsURL = "https://api.myanimelist.net/v2/anime/suggestions"
    
    case animeURLAll = "https://api.myanimelist.net/v2/anime/{id}?fields=synopsis,mean,status,num_episodes,start_season,media_type,average_episode_duration,genres,recommendations,related_anime,related_manga,my_list_status,alternative_titles"
    
    case mangaURLAll = "https://api.myanimelist.net/v2/manga/{id}?fields=synopsis,mean,status,num_chapters,num_volumes,genres,recommendations,related_anime,related_manga,my_list_status,alternative_titles"
    
    case animeSearchURL = "https://api.myanimelist.net/v2/anime?q={query}&fields=mean,status,num_episodes,media_type,start_season,my_list_status"
    case mangaSearchURL = "https://api.myanimelist.net/v2/manga?q={query}&fields=mean,status,num_chapters,media_type,start_date"
    
    case animePopularURL = "https://api.myanimelist.net/v2/anime/ranking?ranking_type=bypopularity&limit=10&fields=mean"
    
    case myAnimelistURL = "https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status,mean,status,num_episodes,media_type,start_season" //all my animelist
    case myAnimelistWithStatusURL = "https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status,mean,status,num_episodes,media_type,start_season&status={status}" //only specific status, like watching, plan to watch, etc

    //url to save changes to animelist
    case patchAnimelistURL = "https://api.myanimelist.net/v2/anime/{id}/my_list_status"
    
    //GET Jikan urls
    case jikanPromoURL = "https://api.jikan.moe/v4/watch/promos"
    case jikanRecommendationsAnimeURL = "https://api.jikan.moe/v4/recommendations/anime"
    
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

struct URLManager {
    func getAnimelistURLForStatus(_ status: UserAnimeStatus?) -> String {
        if let status = status {
            let original = URLs.myAnimelistWithStatusURL.rawValue
            let new = original.replacingOccurrences(of: "{status}", with: status.rawValue)
            print("url with status is \(new)")
            return new
        } else {
            return URLs.myAnimelistURL.rawValue
        }
    }
}

extension String {
    
    func getURLWithId(_ id: Int) -> String {
        if self.contains("{id}") {
            return self.replacingOccurrences(of: "{id}", with: id.description)
        }
        return self
    }
    
}
