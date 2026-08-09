//
//  MediaCoordinator.swift
//  MAL Nana-chan
//

import UIKit

@MainActor
final class MediaCoordinator {
    private weak var navigationController: UINavigationController?
    private let services: ServiceContainer
    private let storyboard: UIStoryboard

    init(navigationController: UINavigationController, services: ServiceContainer) {
        self.navigationController = navigationController
        self.services = services
        self.storyboard = UIStoryboard(name: SceneIdentifier.mainStoryboard, bundle: .main)
    }

    // MARK: - Detail

    /// Opens whichever detail screen matches the item's kind.
    ///
    /// Centralising this switch is what let the list screens drop their own
    /// duplicated anime-or-manga branching.
    func showDetail(for preview: MediaPreview) {
        switch preview.kind {
        case .anime: showAnimeDetail(id: preview.id)
        case .manga: showMangaDetail(id: preview.id)
        }
    }

    func showAnimeDetail(id: Int) {
        let screen: AnimeDetailViewController = instantiate(SceneIdentifier.animeDetail)
        screen.viewModel = AnimeDetailViewModel(
            animeID: id,
            animeService: services.anime,
            reachability: services.reachability,
            isSignedIn: services.tokenStore.isSignedIn
        )
        screen.coordinator = self
        push(screen)
    }

    func showMangaDetail(id: Int) {
        let screen: MangaDetailViewController = instantiate(SceneIdentifier.mangaDetail)
        screen.viewModel = MangaDetailViewModel(
            mangaID: id,
            mangaService: services.manga,
            reachability: services.reachability,
            isSignedIn: services.tokenStore.isSignedIn
        )
        screen.coordinator = self
        push(screen)
    }

    // MARK: - Lists

    func showSeeAll(section: MediaSection) {
        let viewModel = SeeAllViewModel(
            section: section,
            animeService: services.anime,
            mangaService: services.manga,
            canEditList: services.tokenStore.isSignedIn
        )
        let screen = SeeAllViewController(viewModel: viewModel)
        screen.coordinator = self
        push(screen)
    }

    func showSearchResults(query: String) {
        let screen: SearchResultsViewController = instantiate(SceneIdentifier.searchResults)
        screen.viewModel = SearchResultsViewModel(
            query: query,
            animeService: services.anime,
            mangaService: services.manga,
            recentSearches: services.recentSearches,
            canEditList: services.tokenStore.isSignedIn
        )
        screen.coordinator = self
        push(screen)
    }

    // MARK: - Secondary detail

    func showRecommendation(_ recommendation: Recommendation) {
        guard let pair = recommendation.pair else { return }

        let screen: RecommendationDetailViewController = instantiate(SceneIdentifier.recommendationDetail)
        screen.recommendation = recommendation
        screen.pair = pair
        screen.coordinator = self
        push(screen)
    }

    func showThemes(animeID: Int) {
        let screen: ThemesDetailViewController = instantiate(SceneIdentifier.themesDetail)
        screen.viewModel = ThemesDetailViewModel(
            animeID: animeID,
            discoveryService: services.discovery,
            reachability: services.reachability
        )
        push(screen)
    }

    func showAnimeCredits(animeID: Int) {
        let screen: AnimeMoreInformationViewController = instantiate(SceneIdentifier.animeMoreInformation)
        screen.viewModel = AnimeMoreInformationViewModel(
            animeID: animeID,
            discoveryService: services.discovery
        )
        push(screen)
    }

    func showMangaCredits(mangaID: Int) {
        let screen: MangaMoreInformationViewController = instantiate(SceneIdentifier.mangaMoreInformation)
        screen.viewModel = MangaMoreInformationViewModel(
            mangaID: mangaID,
            discoveryService: services.discovery
        )
        push(screen)
    }

    // MARK: - My list sheets

    /// Presents the status sheet for an item.
    ///
    /// `onListChanged` fires only when the user actually saved or removed
    /// something, so a screen can refresh without reloading on a plain cancel.
    func presentListSheet(for target: MediaListTarget, onListChanged: (() -> Void)? = nil) {
        switch target.kind {
        case .anime: presentAnimeListSheet(for: target, onListChanged: onListChanged)
        case .manga: presentMangaListSheet(for: target, onListChanged: onListChanged)
        }
    }

    private func presentAnimeListSheet(for target: MediaListTarget, onListChanged: (() -> Void)?) {
        let screen: MyAnimeStatusViewController = instantiate(SceneIdentifier.myAnimeStatus)
        let viewModel = MyAnimeStatusViewModel(target: target, animeService: services.anime)
        viewModel.onListChanged = onListChanged
        screen.viewModel = viewModel
        presentAsSheet(screen)
    }

    private func presentMangaListSheet(for target: MediaListTarget, onListChanged: (() -> Void)?) {
        let screen: MyMangaStatusViewController = instantiate(SceneIdentifier.myMangaStatus)
        let viewModel = MyMangaStatusViewModel(target: target, mangaService: services.manga)
        viewModel.onListChanged = onListChanged
        screen.viewModel = viewModel
        presentAsSheet(screen)
    }

    // MARK: - Account

    /// The profile button shows the profile when signed in and the sign-in screen
    /// when not.
    func showAccount() {
        services.tokenStore.isSignedIn ? showProfile() : showLogin()
    }

    func showLogin(onSignedIn: (() -> Void)? = nil) {
        let screen: LoginViewController = instantiate(SceneIdentifier.login)
        let viewModel = LoginViewModel(authentication: services.authentication)
        viewModel.onSignedIn = { [weak self] in
            onSignedIn?()
            self?.navigationController?.popViewController(animated: true)
        }
        screen.viewModel = viewModel
        push(screen)
    }

    func showProfile() {
        let screen: ProfileDetailViewController = instantiate(SceneIdentifier.profileDetail)
        let viewModel = ProfileDetailViewModel(
            userProfileService: services.userProfile,
            authentication: services.authentication
        )
        viewModel.onSignedOut = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        screen.viewModel = viewModel
        push(screen)
    }

    // MARK: - Plumbing

    private func instantiate<Screen: UIViewController>(_ identifier: String) -> Screen {
        guard let screen = storyboard.instantiateViewController(withIdentifier: identifier) as? Screen else {
            fatalError("Scene '\(identifier)' in Main.storyboard is not a \(Screen.self).")
        }
        return screen
    }

    private func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func presentAsSheet(_ viewController: UIViewController) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        navigationController?.topViewController?.present(viewController, animated: true)
    }
}
