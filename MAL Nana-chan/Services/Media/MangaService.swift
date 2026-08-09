//
//  MangaService.swift
//  MAL Nana-chan
//

import Foundation

/// Everything the app does with manga. Mirrors `AnimeServicing`.
protocol MangaServicing: AnyObject {

    func manga(id: Int, completion: @escaping (Result<Manga, APIError>) -> Void)

    func favouriteManga(completion: @escaping (Result<MediaPage, APIError>) -> Void)
    func search(query: String, completion: @escaping (Result<MediaPage, APIError>) -> Void)
    func page(url: String, completion: @escaping (Result<MediaPage, APIError>) -> Void)

    func listStatus(mangaID: Int, completion: @escaping (Result<MyMangaListStatus?, APIError>) -> Void)
    func updateListStatus(mangaID: Int, status: MyMangaListStatus, completion: @escaping (Result<Void, APIError>) -> Void)
    func removeFromList(mangaID: Int, completion: @escaping (Result<Void, APIError>) -> Void)
}

final class MangaService: MangaServicing {

    private let apiClient: APIClienting

    init(apiClient: APIClienting) {
        self.apiClient = apiClient
    }

    func manga(id: Int, completion: @escaping (Result<Manga, APIError>) -> Void) {
        apiClient.fetch(MALEndpoint.manga(id: id), as: Manga.self, completion: completion)
    }

    func favouriteManga(completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        fetchPage(MALEndpoint.favouriteManga(), completion: completion)
    }

    func search(query: String, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        fetchPage(MALEndpoint.searchManga(query: query), completion: completion)
    }

    func page(url: String, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        fetchPage(MALEndpoint.page(url), completion: completion)
    }

    func listStatus(mangaID: Int, completion: @escaping (Result<MyMangaListStatus?, APIError>) -> Void) {
        apiClient.fetch(MALEndpoint.mangaListStatus(mangaID: mangaID), as: Manga.self) { result in
            completion(result.map(\.myListStatus))
        }
    }

    func updateListStatus(
        mangaID: Int,
        status: MyMangaListStatus,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        apiClient.send(MALEndpoint.updateMangaListStatus(mangaID: mangaID, status: status), completion: completion)
    }

    func removeFromList(mangaID: Int, completion: @escaping (Result<Void, APIError>) -> Void) {
        apiClient.send(MALEndpoint.deleteMangaListStatus(mangaID: mangaID), completion: completion)
    }

    private func fetchPage(_ endpoint: Endpoint, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        apiClient.fetch(endpoint, as: Response<Manga>.self) { result in
            completion(result.map(MediaPage.init))
        }
    }
}
