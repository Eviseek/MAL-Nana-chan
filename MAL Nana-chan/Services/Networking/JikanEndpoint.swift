//
//  JikanEndpoint.swift
//  MAL Nana-chan
//

import Foundation

/// Jikan requests — the unofficial MAL scraper the app uses for the data MAL's
/// own API doesn't expose (recommendation write-ups, studios, theme songs).
///
/// Kept apart from `MALEndpoint` because it is a *different, third-party* API:
/// its availability is independent of MAL's, and it must never receive MAL
/// credentials. Hence `authorization: .none` on every case.
enum JikanEndpoint {

    private static func endpoint(path: String) -> Endpoint {
        .make(baseURL: AppConfiguration.Jikan.apiBaseURL, path: path, authorization: .none)
    }

    static func animeRecommendations() -> Endpoint {
        endpoint(path: "/recommendations/anime")
    }

    /// `/anime/{id}/full` carries `theme.openings` and `theme.endings`
    static func animeFull(id: Int) -> Endpoint {
        endpoint(path: "/anime/\(id)/full")
    }

    static func mangaFull(id: Int) -> Endpoint {
        endpoint(path: "/manga/\(id)/full")
    }

    /// Trailer feed for the Home screen. Currently answering 504.
    static func promos() -> Endpoint {
        endpoint(path: "/watch/promos")
    }
}
