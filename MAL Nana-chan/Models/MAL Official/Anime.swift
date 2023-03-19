//
//  Anime.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

struct Anime: Codable {
    
    var id: Int
    var title: String
    var main_picture: Picture?
    var alternative_titles: AlternativeTitles?
    var start_date: String?
    var end_date: String?
    var synopsis: String?
    var mean: Float? //score
    var rank: Int?
    var popularity: Int?
    var num_list_users: Int?
    var num_scoring_users: Int?
    var nsfw: NSFWValue?
    var genres: [Genre]?
    var created_at: String?
    var updated_at: String?
    var media_type: MediaType?
    var status: AnimeStatus?
    var my_list_status: MyListStatus?
    var num_episodes: Int?
    var start_season: StartSeason?
    var broadcast: Broadcast?
    var source: AnimeSource?
    var average_episode_duration: Int?
    var rating: Rating?
    var studios: [AnimeStudio]?
    var related_anime: [Node]? //can get only from anime detail call
    var related_manga: [Node]? //can get only from anime detail call
    var recommendations: [Node]? //can get only from anime detail call
    
}

struct Picture: Codable {
    var large: String?
    var medium: String
}

struct AlternativeTitles: Codable {
    var synonyms: [String]?
    var en: String?
    var ja: String?
}

struct Genre: Codable {
    var id: Int
    var name: String
}

struct MyListStatus: Codable {
    var status: UserAnimeStatus?
    var score: Int
    var num_episodes_watched: Int
    var is_rewatching: Bool
    var start_date: String?
    var finish_date: String?
    var priority: Int
    var num_times_rewatched: Int
    var rewatch_value: Int
    var tags: [String]
    var comments: String
    var updated_at: String
}

struct StartSeason: Codable {
    var year: Int
    var season: Season
}

struct Broadcast: Codable {
    var day_of_the_week: Day
    var start_time: String?
}

struct AnimeStudio: Codable {
    var id: Int
    var name: String
}


