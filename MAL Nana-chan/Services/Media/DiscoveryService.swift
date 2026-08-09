//
//  DiscoveryService.swift
//  MAL Nana-chan
//

import Foundation

/// The Jikan-sourced extras: recommendation write-ups, production credits and
/// theme songs.
protocol DiscoveryServicing: AnyObject {

    func animeRecommendations(completion: @escaping (Result<[Recommendation], APIError>) -> Void)

    func animeCredits(animeID: Int, completion: @escaping (Result<AnimeDetails, APIError>) -> Void)
    func mangaCredits(mangaID: Int, completion: @escaping (Result<MangaDetails, APIError>) -> Void)

    /// Opening/ending themes for an anime.
    func themeSongs(animeID: Int, completion: @escaping (Result<ThemeSongs, APIError>) -> Void)

    /// The trailer for the Home screen's video row.
    ///
    /// Completes with `nil` — not a failure — while
    /// `AppConfiguration.Jikan.videoEndpointsAvailable` is `false`, so a dead
    /// third-party feed degrades to "no trailer row" instead of an error.
    func featuredTrailerID(completion: @escaping (String?) -> Void)
}

final class DiscoveryService: DiscoveryServicing {

    private let apiClient: APIClienting

    init(apiClient: APIClienting) {
        self.apiClient = apiClient
    }

    func animeRecommendations(completion: @escaping (Result<[Recommendation], APIError>) -> Void) {
        apiClient.fetch(JikanEndpoint.animeRecommendations(), as: JikanResponse<[Recommendation]>.self) { result in
            completion(result.map { $0.data ?? [] })
        }
    }

    func animeCredits(animeID: Int, completion: @escaping (Result<AnimeDetails, APIError>) -> Void) {
        fetchAnimeDetails(animeID: animeID, completion: completion)
    }

    func mangaCredits(mangaID: Int, completion: @escaping (Result<MangaDetails, APIError>) -> Void) {
        apiClient.fetch(JikanEndpoint.mangaFull(id: mangaID), as: JikanResponse<MangaDetails>.self) { result in
            completion(result.flatMap { response in
                guard let data = response.data else { return .failure(.decoding("Missing manga details")) }
                return .success(data)
            })
        }
    }

    func themeSongs(animeID: Int, completion: @escaping (Result<ThemeSongs, APIError>) -> Void) {
        fetchAnimeDetails(animeID: animeID) { result in
            completion(result.flatMap { details in
                guard let theme = details.theme, !theme.isEmpty else {
                    return .failure(.decoding("No theme songs"))
                }
                return .success(theme)
            })
        }
    }

    func featuredTrailerID(completion: @escaping (String?) -> Void) {
        guard AppConfiguration.Jikan.videoEndpointsAvailable else {
            completion(nil)
            return
        }

        apiClient.fetch(JikanEndpoint.promos(), as: JikanResponse<[Promo]>.self) { result in
            completion(try? result.get().data?.first?.trailer?.youtubeID)
        }
    }

    private func fetchAnimeDetails(animeID: Int, completion: @escaping (Result<AnimeDetails, APIError>) -> Void) {
        apiClient.fetch(JikanEndpoint.animeFull(id: animeID), as: JikanResponse<AnimeDetails>.self) { result in
            completion(result.flatMap { response in
                guard let data = response.data else { return .failure(.decoding("Missing anime details")) }
                return .success(data)
            })
        }
    }
}
