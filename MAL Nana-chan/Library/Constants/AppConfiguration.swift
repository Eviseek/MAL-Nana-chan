//
//  AppConfiguration.swift
//  MAL Nana-chan
//

import Foundation

enum AppConfiguration {

    enum MyAnimeList {
        static let clientID = Bundle.main.requiredConfigurationValue(.malClientID)

        static let apiBaseURL = "https://api.myanimelist.net/v2"
        static let authorizeURL = "https://myanimelist.net/v1/oauth2/authorize"
        static let accessTokenURL = "https://myanimelist.net/v1/oauth2/token"

        static let callbackURL = "nana://authentication"
        static let callbackHost = "authentication"
        static let scope = ""
    }

    enum Jikan {
        static let apiBaseURL = "https://api.jikan.moe/v4"
        static let videoEndpointsAvailable = false
    }

    static let youtubeSearchURL = "https://www.youtube.com/results"

    static let keychainService = "com.eviseek.MAL-Nana-chan"

    static let recentSearchesLifetime: TimeInterval = 7 * 24 * 60 * 60
}
