//
//  MyMangaListStatus.swift
//  MAL Nana-chan
//

import Foundation

/// The signed-in user's own entry for one manga (`my_list_status`).
struct MyMangaListStatus: Codable, Sendable {
    var status: UserMangaStatus
    var score: Int
    var volumesReadCount: Int?
    var chaptersReadCount: Int?
    var isRereading: Bool?
    var startDate: String?
    var finishDate: String?
    var priority: Priority?
    var rereadCount: Int?
    var rereadValue: Int?
    var tags: [String]?
    var comments: String?
    var updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case status
        case score
        case volumesReadCount = "num_volumes_read"
        case chaptersReadCount = "num_chapters_read"
        case isRereading = "rereading"
        case startDate = "start_date"
        case finishDate = "finish_date"
        case priority
        case rereadCount = "num_times_reread"
        case rereadValue = "reread_value"
        case tags
        case comments
        case updatedAt = "updated_at"
    }

    init(
        status: UserMangaStatus,
        score: Int,
        volumesReadCount: Int? = nil,
        chaptersReadCount: Int? = nil,
        priority: Priority? = nil
    ) {
        self.status = status
        self.score = score
        self.volumesReadCount = volumesReadCount
        self.chaptersReadCount = chaptersReadCount
        self.priority = priority
    }
}

extension MyMangaListStatus {

    /// See `MyAnimeListStatus.formParameters`.
    ///
    /// Note the old code built this body but never included `priority`, so the
    /// picker on the manga sheet changed a local value and nothing else — the
    /// server never heard about it.
    var formParameters: [String: String] {
        var parameters = [
            "status": status.rawValue,
            "score": score.description
        ]
        if let chaptersReadCount {
            parameters["num_chapters_read"] = chaptersReadCount.description
        }
        if let volumesReadCount {
            parameters["num_volumes_read"] = volumesReadCount.description
        }
        if let priority {
            parameters["priority"] = priority.rawValue.description
        }
        return parameters
    }
}
