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
    
    case mangaFavoriteURL = "https://api.myanimelist.net/v2/manga/ranking?ranking_type=favorite&fields=mean"
    
    case animeURLAll = "https://api.myanimelist.net/v2/anime/{id}?fields=synopsis,mean,status,num_episodes,start_season,media_type,average_episode_duration,genres,recommendations,related_anime,related_manga,my_list_status,alternative_titles"
    
    case mangaURLAll = "https://api.myanimelist.net/v2/manga/{id}?fields=synopsis,mean,status,num_chapters,num_volumes,media_type,genres,recommendations,related_anime,related_manga,my_list_status,alternative_titles"
    
    case animeSearchURL = "https://api.myanimelist.net/v2/anime?q={query}&fields=mean,status,num_episodes,media_type,start_season,my_list_status"
    case mangaSearchURL = "https://api.myanimelist.net/v2/manga?q={query}&fields=mean,status,num_chapters,media_type,start_date"
    
    case animePopularURL = "https://api.myanimelist.net/v2/anime/ranking?ranking_type=bypopularity&limit=10&fields=mean"
    
    case myAnimelistURL = "https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status,mean,status,num_episodes,media_type,start_season" //all my animelist
    case myAnimelistWithStatusURL = "https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status,mean,status,num_episodes,media_type,start_season&status={status}" //only specific status, like watching, plan to watch, etc
    
    case animeGetListURL = "https://api.myanimelist.net/v2/anime/{id}?fields=my_list_status"
    case mangaGetListURL = "https://api.myanimelist.net/v2/manga/{id}?fields=my_list_status"

    //url to save changes to anime or manga list
    case animeListStatusURL = "https://api.myanimelist.net/v2/anime/{id}/my_list_status"
    case mangaListStatusURL = "https://api.myanimelist.net/v2/manga/{id}/my_list_status"
    
    //GET Jikan urls

    // DISABLED 2026-08-08 — these two return HTTP 504 from Jikan itself:
    //   {"status":504,"type":"BadResponseException",
    //    "message":"Jikan failed to connect to MyAnimeList..."}
    // Jikan scrapes MAL's website, and MAL appears to have changed the pages
    // these endpoints read. Verified down over repeated clean probes; the whole
    // video family is affected (watch/promos, watch/promos/popular,
    // anime/{id}/videos). Nothing to fix on our side — re-enable when Jikan
    // recovers, and check https://status.jikan.moe first.
    //
    // Note: /anime/{id}/full (jikanAnimeMoreInfoURL below) still returns 200 and
    // already carries `theme.openings` / `theme.endings`, so the Themes screen
    // could be sourced from there instead if this stays broken.
    //
    // case jikanPromoURL = "https://api.jikan.moe/v4/watch/promos"
    // case jikanThemesURL = "https://api.jikan.moe/v4/anime/{id}/themes"

    case jikanRecommendationsAnimeURL = "https://api.jikan.moe/v4/recommendations/anime"
    case jikanTopMangaURL = "https://api.jikan.moe/v4/top/manga"
    case jikanAnimeMoreInfoURL = "https://api.jikan.moe/v4/anime/{id}/full"
    case jikanMangaMoreInfoURL = "https://api.jikan.moe/v4/manga/{id}/full"
    
    case myUserProfileURL = "https://api.myanimelist.net/v2/users/@me"

    
    //Home View Controller URLs
    
    case seasonalAnimeURL = "https://api.myanimelist.net/v2/anime/season/{year}/{season}?fields=list_status,mean,status,num_episodes,media_type,start_season"
    
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
    
    func getURLForThisSeason() -> String {
        var original = URLs.seasonalAnimeURL.rawValue
        let season = SeasonManager().getThisSeason().rawValue
        var year = Calendar.current.component(.year, from: Date())
        let withYear = original.replacingOccurrences(of: "{year}", with: year.description)
        let completedURL = withYear.replacingOccurrences(of: "{season}", with: season)
        return completedURL.lowercased()
    }
    
    func getURLForNextSeason() -> String {
        var original = URLs.seasonalAnimeURL.rawValue
        let nextSeasonTupple = SeasonManager().getUpcomingSeason()
        let nextSeason = nextSeasonTupple.0.stringValue()
        print("I AM NEXT SEASON" ,nextSeason)
        var nextSeasonYear = Calendar.current.component(.year, from: Date())
        if nextSeasonTupple.1 == true {
            nextSeasonYear += 1
        }
        let withYear = original.replacingOccurrences(of: "{year}", with: nextSeasonYear.description)
        let completedURL = withYear.replacingOccurrences(of: "{season}", with: nextSeason)
        return completedURL.lowercased()
    }
    
    func getURLForCustomSeason(season: Season, year: Int) -> String {
        var original = URLs.seasonalAnimeURL.rawValue
        let withYear = original.replacingOccurrences(of: "{year}", with: year.description)
        let completedURL = withYear.replacingOccurrences(of: "{season}", with: season.rawValue)
        return completedURL.lowercased()
    }
    
    func getURLForId(_ id: Int, url: String) -> String {
        if url.contains("{id}") {
            return url.replacingOccurrences(of: "{id}", with: id.description)
        }
        return url
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
