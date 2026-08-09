//
//  Manga.swift
//  MAL Nana-chan
//

import Foundation

/// A manga as MAL describes it. See `Anime` for why nearly everything is
/// optional.
struct Manga: Codable, Sendable {

    let id: Int
    let title: String
    let mainPicture: Picture?
    let alternativeTitles: AlternativeTitles?
    let startDate: String?
    let endDate: String?
    let synopsis: String?
    let score: Float?
    let rank: Int?
    let popularity: Int?
    let listUsersCount: Int?
    let scoringUsersCount: Int?
    let nsfw: NSFWValue?
    let genres: [Genre]?
    let createdAt: String?
    let updatedAt: String?
    let mediaType: MangaMediaType?
    let status: MangaStatus?
    var myListStatus: MyMangaListStatus?
    let volumesCount: Int?
    let chaptersCount: Int?

    /// Only present on the detail endpoint.
    let relatedAnime: [Node<Anime>]?
    let relatedManga: [Node<Manga>]?
    let recommendations: [Node<Manga>]?

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case mainPicture = "main_picture"
        case alternativeTitles = "alternative_titles"
        case startDate = "start_date"
        case endDate = "end_date"
        case synopsis
        case score = "mean"
        case rank
        case popularity
        case scoringUsersCount = "num_scoring_users"
        case listUsersCount = "num_list_users"
        case nsfw
        case genres
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mediaType = "media_type"
        case status
        case myListStatus = "my_list_status"
        case volumesCount = "num_volumes"
        case chaptersCount = "num_chapters"
        case relatedAnime = "related_anime"
        case relatedManga = "related_manga"
        case recommendations
    }
}

extension Manga {

    var synonymsText: String? {
        guard let synonyms = alternativeTitles?.synonyms, !synonyms.isEmpty else { return nil }
        return synonyms.joined(separator: ", ")
    }
}
