//
//  Manga.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 25.03.2023.
//

import Foundation

struct Manga: Codable {
    
    var id: Int
    var title: String
    var mainPicture: Picture?
    var alternativeTitles: AlternativeTitles?
    var startDate: String?
    var endDate: String?
    var synopsis: String?
    var score: Float? //score
    var rank: Int?
    var popularity: Int?
    var listUsersCount: Int?
    var scoringUsersCount: Int?
    var nsfw: NSFWValue?
    var genres: [Genre]?
    var createdAt: String?
    var updatedAt: String?
    var mediaType: MangaMediaType?
    var status: MangaStatus?
    var myListStatus: MyMangaListStatus? //CHANGE
    var volumesCount: Int?
    var chaptersCount: Int?
 //   var authors: [Node<Person>]?
    var relatedAnime: [Node<Anime>]? //can get only from detail call
    var relatedManga: [Node<Manga>]? //can get only from detail call
    var recommendations: [Node<Manga>]? //can get only from detail call
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case mainPicture = "main_picture"
        case alternativeTitles = "alternative_titles"
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
        case volumesCount = "num_volumes"
        case chaptersCount = "num_chapters"
     //   case authors = "authors"
        case relatedAnime = "related_anime"
        case relatedManga = "related_manga"
        case recommendations = "recommendations"
    }
    
}

struct MyMangaListStatus: Codable {
    var status: UserMangaStatus
    var score: Int
    var volumesReadCount: Int?
    var chaptersReadCount: Int?
    var isRereading: Bool?
    var startDate: String?
    let finishDate: String?
    var priority: Priority?
    var rereadCount: Int?
    var rereadValue: Int?
    var tags: [String]?
    var comments: String?
    var updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case score = "score"
        case volumesReadCount = "num_volumes_read"
        case chaptersReadCount = "num_chapters_read"
        case isRereading = "rereading"
        case startDate = "start_date"
        case finishDate = "finish_date"
        case priority = "priority"
        case rereadCount = "num_times_reread"
        case rereadValue = "reread_value"
        case tags = "tags"
        case comments = "comments"
        case updatedAt = "updated_at"
    }
    
}


struct PersonRoleEdge: Codable {
    var node: PersonBase?
    var role: String?
}

struct PersonBase: Codable {
    var id: Int?
    var first_name: String?
    var last_name: String?
}


struct RelatedAnimeEdge: Codable {
    var node: Anime?
   // var relation_type: String?
    var relation_type_formatted: String?
}


struct RelatedMangaEdge: Codable {
    var node: Manga?
    var relation_type_formatted: String?
}




