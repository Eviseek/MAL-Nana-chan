//
//  Anime.swift
//  MAL Nana-chan
//

import Foundation

/// An anime as MAL describes it.
///
/// Almost everything is optional, and that is not defensiveness — MAL returns
/// only `id`, `title` and `main_picture` unless the request's `fields` parameter
/// asks for more (see `MALEndpoint.Fields`). The same struct therefore models
/// both a one-line search hit and a fully populated detail response.
struct Anime: Codable, Sendable {

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
    let mediaType: AnimeMediaType?
    let status: AnimeStatus?
    var myListStatus: MyAnimeListStatus?
    let episodesCount: Int?
    let startSeason: StartSeason?
    let broadcast: Broadcast?
    let source: AnimeSource?
    let episodeDurationSec: Int?
    let rating: Rating?
    let studios: [AnimeStudio]?

    /// Only present on the detail endpoint.
    let relatedAnime: [Node<Anime>]?
    let relatedManga: [Node<Manga>]?
    let recommendations: [Node<Anime>]?

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
        case episodesCount = "num_episodes"
        case startSeason = "start_season"
        case broadcast
        case source
        case episodeDurationSec = "average_episode_duration"
        case rating
        case studios = "studios"
        case relatedAnime = "related_anime"
        case relatedManga = "related_manga"
        case recommendations
    }
}

extension Anime {

    /// Episode length in whole minutes, if MAL gave us one.
    ///
    /// MAL reports this in seconds and sends `0` for titles it doesn't know,
    /// which the old code turned into a literal "0" on screen.
    var episodeDurationMinutes: Int? {
        guard let episodeDurationSec, episodeDurationSec > 0 else { return nil }
        return episodeDurationSec / 60
    }

    /// Synonyms as one readable line, or `nil` when there are none.
    ///
    /// The old version built `"a, b, "` with a trailing separator and then only
    /// skipped assigning it when the *whole string* was empty, so a title with no
    /// synonyms kept whatever placeholder the storyboard had.
    var synonymsText: String? {
        guard let synonyms = alternativeTitles?.synonyms, !synonyms.isEmpty else { return nil }
        return synonyms.joined(separator: ", ")
    }
}
