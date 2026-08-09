//
//  ServiceContainer.swift
//  MAL Nana-chan
//

import Foundation

/// The app's dependencies, built once at launch and handed down.
struct ServiceContainer {

    let tokenStore: TokenStoring
    let authentication: AuthenticationServicing
    let reachability: ReachabilityObserving
    let recentSearches: RecentSearchesStoring

    let anime: AnimeServicing
    let manga: MangaServicing
    let discovery: DiscoveryServicing
    let userProfile: UserProfileServicing

    /// The production graph.
    static func live() -> ServiceContainer {
        let tokenStore = KeychainTokenStore()
        let apiClient = APIClient(tokenStore: tokenStore)

        return ServiceContainer(
            tokenStore: tokenStore,
            authentication: AuthenticationService(tokenStore: tokenStore),
            reachability: ReachabilityService(),
            recentSearches: RecentSearchesStore(),
            anime: AnimeService(apiClient: apiClient),
            manga: MangaService(apiClient: apiClient),
            discovery: DiscoveryService(apiClient: apiClient),
            userProfile: UserProfileService(apiClient: apiClient)
        )
    }
}
