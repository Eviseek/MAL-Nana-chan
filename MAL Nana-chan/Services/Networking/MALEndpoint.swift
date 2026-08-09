//
//  MALEndpoint.swift
//  MAL Nana-chan
//

import Foundation

/// Every MyAnimeList request the app makes.
enum MALEndpoint {

    /// MAL returns only `id`, `title` and `main_picture` unless `fields` asks for
    /// more, so every list request has to name what the UI needs.
    private enum Fields {
        static let animePreview = "list_status,mean,status,num_episodes,media_type,start_season"
        static let animeSearch = "mean,status,num_episodes,media_type,start_season,my_list_status"
        static let mangaSearch = "mean,status,num_chapters,media_type,start_date"
        static let ranking = "mean"
        static let listStatusOnly = "my_list_status"

        static let animeDetail = """
            synopsis,mean,status,num_episodes,start_season,media_type,\
            average_episode_duration,genres,recommendations,related_anime,\
            related_manga,my_list_status,alternative_titles
            """

        static let mangaDetail = """
            synopsis,mean,status,num_chapters,num_volumes,media_type,genres,\
            recommendations,related_anime,related_manga,my_list_status,\
            alternative_titles
            """
    }

    private static func endpoint(
        path: String,
        query: [(name: String, value: String)] = [],
        method: Endpoint.Method = .get,
        authorization: Endpoint.Authorization = .userToken,
        formBody: [String: String] = [:]
    ) -> Endpoint {
        .make(
            baseURL: AppConfiguration.MyAnimeList.apiBaseURL,
            path: path,
            query: query,
            method: method,
            authorization: authorization,
            formBody: formBody
        )
    }

    // MARK: - Reads

    static func anime(id: Int) -> Endpoint {
        endpoint(path: "/anime/\(id)", query: [("fields", Fields.animeDetail)])
    }

    static func manga(id: Int) -> Endpoint {
        endpoint(path: "/manga/\(id)", query: [("fields", Fields.mangaDetail)])
    }

    static func seasonalAnime(season: Season, year: Int) -> Endpoint {
        endpoint(
            path: "/anime/season/\(year)/\(season.rawValue)",
            query: [("fields", Fields.animePreview)]
        )
    }

    static func popularAnime(limit: Int = 10) -> Endpoint {
        endpoint(path: "/anime/ranking", query: [
            ("ranking_type", "bypopularity"),
            ("limit", limit.description),
            ("fields", Fields.ranking)
        ])
    }

    static func favouriteManga() -> Endpoint {
        endpoint(path: "/manga/ranking", query: [
            ("ranking_type", "favorite"),
            ("fields", Fields.ranking)
        ])
    }

    static func searchAnime(query: String) -> Endpoint {
        endpoint(path: "/anime", query: [
            ("q", query),
            ("fields", Fields.animeSearch)
        ])
    }

    static func searchManga(query: String) -> Endpoint {
        endpoint(path: "/manga", query: [
            ("q", query),
            ("fields", Fields.mangaSearch)
        ])
    }

    static func myProfile() -> Endpoint {
        endpoint(path: "/users/@me")
    }

    /// The signed-in user's anime list, optionally filtered to one status.
    static func myAnimelist(status: UserAnimeStatus?) -> Endpoint {
        var query: [(name: String, value: String)] = [("fields", Fields.animePreview)]
        if let status {
            query.append(("status", status.rawValue))
        }
        return endpoint(path: "/users/@me/animelist", query: query)
    }

    // MARK: - My list status

    /// Just the user's own entry for one title — used by the status sheets, which
    /// need the freshest value and nothing else.
    static func animeListStatus(animeID: Int) -> Endpoint {
        endpoint(path: "/anime/\(animeID)", query: [("fields", Fields.listStatusOnly)])
    }

    static func mangaListStatus(mangaID: Int) -> Endpoint {
        endpoint(path: "/manga/\(mangaID)", query: [("fields", Fields.listStatusOnly)])
    }

    static func updateAnimeListStatus(animeID: Int, status: MyAnimeListStatus) -> Endpoint {
        endpoint(
            path: "/anime/\(animeID)/my_list_status",
            method: .patch,
            formBody: status.formParameters
        )
    }

    static func updateMangaListStatus(mangaID: Int, status: MyMangaListStatus) -> Endpoint {
        endpoint(
            path: "/manga/\(mangaID)/my_list_status",
            method: .patch,
            formBody: status.formParameters
        )
    }

    static func deleteAnimeListStatus(animeID: Int) -> Endpoint {
        endpoint(path: "/anime/\(animeID)/my_list_status", method: .delete)
    }

    static func deleteMangaListStatus(mangaID: Int) -> Endpoint {
        endpoint(path: "/manga/\(mangaID)/my_list_status", method: .delete)
    }

    // MARK: - Paging

    /// A `paging.next` link, which MAL returns fully formed.
    static func page(_ url: String) -> Endpoint {
        .absolute(url, authorization: .userToken)
    }
}
