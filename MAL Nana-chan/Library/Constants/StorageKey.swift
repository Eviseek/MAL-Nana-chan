//
//  StorageKey.swift
//  MAL Nana-chan
//

import Foundation

/// Keys used to persist data, split by *where* the data lives.
enum StorageKey {

    enum Keychain {
        static let accessToken = "userToken"
        static let tokenExpiration = "tokenExpiration"
    }

    enum Defaults {
        static let recentSearches = "recentSearchesArr"
        static let recentSearchesSavedAt = "RecentSearchesLastSave"
    }
}

/// Storyboard scene identifiers.
enum SceneIdentifier {
    static let animeDetail = "AnimeDetailViewController"
    static let mangaDetail = "MangaDetailViewController"
    static let recommendationDetail = "RecommendationDetailViewController"
    static let searchResults = "SearchResultsViewController"
    static let myAnimeStatus = "MyAnimeStatusViewController"
    static let myMangaStatus = "MyMangaStatusViewController"
    static let animeMoreInformation = "AnimeMoreInformationViewController"
    static let mangaMoreInformation = "MangaMoreInformationViewController"
    static let themesDetail = "ThemesDetailViewController"
    static let login = "LoginViewController"
    static let profileDetail = "ProfileDetailViewController"

    static let mainStoryboard = "Main"
}
