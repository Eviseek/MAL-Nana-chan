//
//  Coordinator.swift
//  MAL Nana-chan
//

import UIKit

/// An object that owns a piece of the app's navigation.
///
/// `@MainActor` because navigation is UIKit work by definition — pushing a view
/// controller, reading a navigation stack, instantiating a storyboard scene. The
/// isolation is declared on the protocol so every conformer inherits it and no
/// call site has to hop actors.
@MainActor
protocol Coordinator: AnyObject {
    func start()
}
