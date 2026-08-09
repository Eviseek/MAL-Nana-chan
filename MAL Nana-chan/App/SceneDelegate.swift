//
//  SceneDelegate.swift
//  MAL Nana-chan
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        guard let services = (UIApplication.shared.delegate as? AppDelegate)?.services else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let coordinator = AppCoordinator(window: window, services: services)
        appCoordinator = coordinator
        coordinator.start()
    }

    /// MAL redirects back into the app on the `nana://` scheme after sign-in.
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard
            let url = URLContexts.first?.url,
            let services = (UIApplication.shared.delegate as? AppDelegate)?.services
        else {
            return
        }
        _ = services.authentication.handleCallback(url: url)
    }
}

// The five empty lifecycle stubs Xcode generates (`sceneDidDisconnect`,
// `sceneDidBecomeActive`, and so on) are gone. They contained nothing but
// Apple's template comments, and an empty override is indistinguishable from a
// deliberate no-op when reading the file.
