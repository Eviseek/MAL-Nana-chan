//
//  MyAnimeListStatus.swift
//  MAL Nana-chan
//

import Foundation

/// The signed-in user's own entry for one anime (`my_list_status`).
struct MyAnimeListStatus: Codable, Sendable {
    var status: UserAnimeStatus
    var score: Int
    var episodesWatchedCount: Int?
    var isRewatching: Bool?
    var startDate: String?
    var finishDate: String?
    var priority: Priority?
    var rewatchedCount: Int?
    var rewatchValue: Int?
    var tags: [String]?
    var comments: String?
    var updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case status
        case score
        case episodesWatchedCount = "num_episodes_watched"
        case isRewatching = "is_rewatching"
        case startDate = "start_date"
        case finishDate = "finish_date"
        case priority
        case rewatchedCount = "num_times_rewatched"
        case rewatchValue = "rewatch_value"
        case tags
        case comments
        case updatedAt = "updated_at"
    }

    init(
        status: UserAnimeStatus,
        score: Int,
        episodesWatchedCount: Int? = nil,
        priority: Priority? = nil
    ) {
        self.status = status
        self.score = score
        self.episodesWatchedCount = episodesWatchedCount
        self.priority = priority
    }
}

extension MyAnimeListStatus {

    /// The form body for a `PATCH …/my_list_status` request.
    ///
    /// Only fields we actually have are sent. `PATCH` is a partial update, so an
    /// omitted field keeps its current server-side value — which is the right
    /// behaviour and also avoids the crash the old code had, where a `nil`
    /// episode count was force-unwrapped into the parameters.
    var formParameters: [String: String] {
        var parameters = [
            "status": status.rawValue,
            "score": score.description
        ]
        if let episodesWatchedCount {
            parameters["num_watched_episodes"] = episodesWatchedCount.description
        }
        if let priority {
            parameters["priority"] = priority.rawValue.description
        }
        return parameters
    }
}
