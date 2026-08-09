//
//  TabBarController.swift
//  MAL Nana-chan
//

import UIKit

/// Hosts the three tabs and the account button in the navigation bar.
final class TabBarController: UITabBarController {

    /// Set by `AppCoordinator`. The button used to decide for itself whether to
    /// push the login screen or the profile screen — including reading a global
    /// `TokenHandler.isUserLoggedIn` and instantiating both from the storyboard.
    var onAccountTapped: (() -> Void)?

    @IBAction private func profileButtonClicked(_ sender: UIBarButtonItem) {
        onAccountTapped?()
    }
}
