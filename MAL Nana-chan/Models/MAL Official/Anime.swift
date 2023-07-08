//
//  Anime.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

struct Anime: Codable {
    
    let id: Int
    let title: String
    let mainPicture: Picture?
    let alternativeTitle: AlternativeTitles?
    let startDate: String?
    let endDate: String?
    let synopsis: String?
    let score: Float? //score
    let rank: Int?
    let popularity: Int?
    let listUsersCount: Int?
    let scoringUsersCount: Int?
    let nsfw: NSFWValue?
    let genres: [Genre]?
    let createdAt: String?
    let updatedAt: String?
    let mediaType: AnimeMediaType? //add manga media type
    let status: AnimeStatus? //add manga status
    var myListStatus: MyListStatus?
    let episodesCount: Int? //num_volumes
    let startSeason: StartSeason? //nil
    let broadcast: Broadcast? //nil
    let source: AnimeSource? //nil
    let episodeDurationSec: Int?
    let rating: Rating?
    let studios: [AnimeStudio]?
   // let related_anime: [Node]? //can get only from anime detail call
  //  let related_manga: [Node]? //can get only from anime detail call
  //  let recommendations: [Node]? //can get only from anime detail call
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case mainPicture = "main_picture"
        case alternativeTitle = "alternative_titles"
        case startDate = "start_date"
        case endDate = "end_date"
        case synopsis = "synopsis"
        case score = "mean"
        case rank = "rank"
        case popularity = "popularity"
        case scoringUsersCount = "num_scoring_users"
        case listUsersCount = "num_list_users"
        case nsfw = "nsfw"
        case genres = "genres"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mediaType = "media_type"
        case status = "status"
        case myListStatus = "my_list_status"
        case episodesCount = "num_episodes"
        case startSeason = "start_season"
        case broadcast = "broadcast"
        case source = "source"
        case episodeDurationSec = "average_episode_duration"
        case rating = "rating"
        case studios = "studios"
    }
  
}

struct Picture: Codable {
    let large: String?
    let medium: String
}

struct AlternativeTitles: Codable {
    let synonyms: [String]?
    let en: String?
    let ja: String?
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct MyListStatus: Codable {
    var status: UserAnimeStatus
    var score: Int
    var episodesWatchedCount: Int?
    var isRewatching: Bool?
    var startDate: String?
    let finishDate: String?
    var priority: Int?
    var rewatchedCount: Int?
    var rewarchValue: Int?
    var tags: [String]?
    var comments: String?
    var updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case score = "score"
        case episodesWatchedCount = "num_episodes_watched"
        case isRewatching = "is_rewatching"
        case startDate = "start_date"
        case finishDate = "finish_date"
        case priority = "priority"
        case rewatchedCount = "num_times_rewatched"
        case rewarchValue = "rewatch_value"
        case tags = "tags"
        case comments = "comments"
        case updatedAt = "updated_at"
    }
    
}

struct StartSeason: Codable {
    let year: Int
    let season: Season
}

struct Broadcast: Codable {
    var day_of_the_week: Day
    var start_time: String?
}

struct AnimeStudio: Codable {
    var id: Int
    let name: String
}


