//
//  AppDelegate.swift
//  MAL Nana-chan
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Built once here and handed to the scene delegate, so the whole app shares
    /// one API client, one token store and one reachability monitor.
    let services = ServiceContainer.live()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureNavigationBarAppearance()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    /// The MAL-branded navigation bar.
    ///
    /// The `if #available(iOS 15, *)` guard this used to sit behind is gone: the
    /// deployment target is iOS 16, so the check was always true and only served
    /// to hide the code from readers.
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .mal

        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
    }
}

// The old `didFinishLaunching` also called `DateFormatManager()` and threw the
// result away — the initialiser was empty, so it did nothing at all — and started
// reachability monitoring here. Monitoring now starts in `AppCoordinator.start()`,
// next to the screens that observe it.
