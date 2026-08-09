//
//  AnimeService.swift
//  MAL Nana-chan
//

import Foundation

/// Everything the app does with anime.
protocol AnimeServicing: AnyObject {

    func anime(id: Int, completion: @escaping (Result<Anime, APIError>) -> Void)

    func seasonalAnime(season: Season, year: Int, completion: @escaping (Result<MediaPage, APIError>) -> Void)
    func popularAnime(completion: @escaping (Result<MediaPage, APIError>) -> Void)
    func search(query: String, completion: @escaping (Result<MediaPage, APIError>) -> Void)

    /// Follows a `paging.next` link from any of the list calls above.
    func page(url: String, completion: @escaping (Result<MediaPage, APIError>) -> Void)

    // MARK: My list

    /// The user's entry for one anime, fetched fresh.
    func listStatus(animeID: Int, completion: @escaping (Result<MyAnimeListStatus?, APIError>) -> Void)

    func updateListStatus(animeID: Int, status: MyAnimeListStatus, completion: @escaping (Result<Void, APIError>) -> Void)
    func removeFromList(animeID: Int, completion: @escaping (Result<Void, APIError>) -> Void)

    func myAnimelist(status: UserAnimeStatus?, completion: @escaping (Result<AnimelistPage, APIError>) -> Void)
    func myAnimelistPage(url: String, completion: @escaping (Result<AnimelistPage, APIError>) -> Void)
}

final class AnimeService: AnimeServicing {

    private let apiClient: APIClienting

    init(apiClient: APIClienting) {
        self.apiClient = apiClient
    }

    func anime(id: Int, completion: @escaping (Result<Anime, APIError>) -> Void) {
        apiClient.fetch(MALEndpoint.anime(id: id), as: Anime.self, completion: completion)
    }

    func seasonalAnime(season: Season, year: Int, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        fetchPage(MALEndpoint.seasonalAnime(season: season, year: year), completion: completion)
    }

    func popularAnime(completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        fetchPage(MALEndpoint.popularAnime(), completion: completion)
    }

    func search(query: String, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        fetchPage(MALEndpoint.searchAnime(query: query), completion: completion)
    }

    func page(url: String, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        fetchPage(MALEndpoint.page(url), completion: completion)
    }

    // MARK: - My list

    func listStatus(animeID: Int, completion: @escaping (Result<MyAnimeListStatus?, APIError>) -> Void) {
        apiClient.fetch(MALEndpoint.animeListStatus(animeID: animeID), as: Anime.self) { result in
            completion(result.map(\.myListStatus))
        }
    }

    func updateListStatus(
        animeID: Int,
        status: MyAnimeListStatus,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        apiClient.send(MALEndpoint.updateAnimeListStatus(animeID: animeID, status: status), completion: completion)
    }

    func removeFromList(animeID: Int, completion: @escaping (Result<Void, APIError>) -> Void) {
        apiClient.send(MALEndpoint.deleteAnimeListStatus(animeID: animeID), completion: completion)
    }

    func myAnimelist(status: UserAnimeStatus?, completion: @escaping (Result<AnimelistPage, APIError>) -> Void) {
        fetchAnimelist(MALEndpoint.myAnimelist(status: status), completion: completion)
    }

    func myAnimelistPage(url: String, completion: @escaping (Result<AnimelistPage, APIError>) -> Void) {
        fetchAnimelist(MALEndpoint.page(url), completion: completion)
    }

    // MARK: - Helpers

    /// The two `map` shims below are the whole reason the screens above can be
    /// non-generic: the API's envelope types stop here.
    private func fetchPage(_ endpoint: Endpoint, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        apiClient.fetch(endpoint, as: Response<Anime>.self) { result in
            completion(result.map(MediaPage.init))
        }
    }

    private func fetchAnimelist(_ endpoint: Endpoint, completion: @escaping (Result<AnimelistPage, APIError>) -> Void) {
        apiClient.fetch(endpoint, as: UserAnimelist.self) { result in
            completion(result.map(AnimelistPage.init))
        }
    }
}
