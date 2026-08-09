//
//  AppCoordinator.swift
//  MAL Nana-chan
//

import UIKit

/// Builds the window, the tab bar and the three tab screens.
///
/// The storyboard is still the source of the layout — it holds the navigation
/// controller, the tab bar and every scene — but it no longer *starts* the app.
/// `UISceneStoryboardFile` was removed from Info.plist so this type owns the root
/// instead: that is the only way the tab screens can be handed their view models
/// and services, since a storyboard can only ever call a no-argument initialiser.
@MainActor
final class AppCoordinator: Coordinator {

    private let window: UIWindow
    private let services: ServiceContainer

    /// Retained for the lifetime of the app — it is the destination of every
    /// navigation closure the tab screens hand out.
    private var mediaCoordinator: MediaCoordinator?

    init(window: UIWindow, services: ServiceContainer) {
        self.window = window
        self.services = services
    }

    func start() {
        services.reachability.startMonitoring()

        let storyboard = UIStoryboard(name: SceneIdentifier.mainStoryboard, bundle: .main)
        guard let root = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Main.storyboard's initial scene must be a UINavigationController.")
        }

        let coordinator = MediaCoordinator(navigationController: root, services: services)
        mediaCoordinator = coordinator

        configureTabs(in: root, coordinator: coordinator)

        window.rootViewController = root
        window.makeKeyAndVisible()
    }

    // MARK: - Tabs

    private func configureTabs(in root: UINavigationController, coordinator: MediaCoordinator) {
        guard let tabBarController = root.viewControllers.first as? TabBarController else {
            fatalError("Main.storyboard's navigation controller must contain the TabBarController.")
        }

        tabBarController.onAccountTapped = { [weak coordinator] in
            coordinator?.showAccount()
        }

        let tabs = tabBarController.viewControllers ?? []
        for tab in tabs {
            configure(tab: tab, coordinator: coordinator)
        }
    }

    /// Injects each tab's view model.
    ///
    /// A `switch` over the concrete types rather than a protocol with an
    /// associated view model: three cases, and the alternative would need type
    /// erasure that buys nothing here.
    private func configure(tab: UIViewController, coordinator: MediaCoordinator) {
        switch tab {
        case let home as HomeViewController:
            home.viewModel = HomeViewModel(
                animeService: services.anime,
                discoveryService: services.discovery,
                reachability: services.reachability
            )
            home.coordinator = coordinator

        case let explore as ExploreViewController:
            explore.viewModel = ExploreViewModel(
                mangaService: services.manga,
                discoveryService: services.discovery,
                recentSearches: services.recentSearches,
                reachability: services.reachability
            )
            explore.coordinator = coordinator

        case let animelist as AnimelistViewController:
            animelist.viewModel = AnimelistViewModel(
                animeService: services.anime,
                tokenStore: services.tokenStore,
                reachability: services.reachability
            )
            animelist.coordinator = coordinator

        default:
            // A tab the storyboard has but this build doesn't configure — the
            // Settings placeholder, for instance. Nothing to inject.
            break
        }
    }
}
