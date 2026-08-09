//
//  AnimelistRow.swift
//  MAL Nana-chan
//

import Foundation

/// One row of the user's anime list: the title *and* their entry for it.
///
/// The animelist cell needs both halves, so it gets its own view-facing type
/// rather than trying to stretch `MediaPreview` to carry list fields that no
/// other surface uses.
struct AnimelistRow {
    let preview: MediaPreview
    let listStatus: MyAnimeListStatus
}

extension AnimelistRow {

    init(_ entry: AnimelistEntry) {
        var preview = entry.node.preview
        preview.isOnUserList = true
        self.preview = preview
        self.listStatus = entry.listStatus
    }

    /// "12/24" — episodes watched over episodes that exist.
    var progressText: String {
        let watched = listStatus.episodesWatchedCount?.description ?? "0"
        let total = preview.unitCount.map(String.init) ?? "?"
        return "\(watched)/\(total)"
    }

    var scoreText: String { listStatus.score.description }
    var statusText: String { listStatus.status.displayName }
    /// MAL treats a missing priority as low.
    var priorityText: String { (listStatus.priority ?? .low).displayName }
}

/// One page of the user's list.
struct AnimelistPage {
    var rows: [AnimelistRow]
    var nextPageURL: String?
}

extension AnimelistPage {

    init(_ list: UserAnimelist) {
        rows = list.data.map(AnimelistRow.init)
        nextPageURL = list.paging?.next
    }
}
