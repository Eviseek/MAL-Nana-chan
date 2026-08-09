//
//  UserAnimelist.swift
//  MAL Nana-chan
//

import Foundation

/// `/users/@me/animelist` — the user's list, one page at a time.
///
/// It needs its own envelope rather than reusing `Response<Anime>` because MAL
/// puts the list entry *beside* the anime here (`list_status`) instead of inside
/// it (`my_list_status`).
struct UserAnimelist: Codable, Sendable {
    var data: [AnimelistEntry]
    var paging: Paging?
}

struct AnimelistEntry: Codable, Sendable {
    let node: Anime
    let listStatus: MyAnimeListStatus

    private enum CodingKeys: String, CodingKey {
        case node
        case listStatus = "list_status"
    }
}
