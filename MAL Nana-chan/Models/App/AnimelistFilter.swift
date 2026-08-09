//
//  AnimelistFilter.swift
//  MAL Nana-chan
//

import Foundation

/// One tab of the status strip above the user's anime list.
struct AnimelistFilter {
    let title: String
    /// `nil` means "no status filter" — the whole list.
    let status: UserAnimeStatus?
}

extension AnimelistFilter {

    /// The strip's tabs, in display order.
    static let all: [AnimelistFilter] = [
        AnimelistFilter(title: Strings.Animelist.all, status: nil),
        AnimelistFilter(title: UserAnimeStatus.watching.displayName, status: .watching),
        AnimelistFilter(title: UserAnimeStatus.planToWatch.displayName, status: .planToWatch),
        AnimelistFilter(title: UserAnimeStatus.completed.displayName, status: .completed),
        AnimelistFilter(title: UserAnimeStatus.onHold.displayName, status: .onHold),
        AnimelistFilter(title: UserAnimeStatus.dropped.displayName, status: .dropped)
    ]
}
