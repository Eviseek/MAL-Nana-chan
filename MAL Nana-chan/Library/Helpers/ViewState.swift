//
//  ViewState.swift
//  MAL Nana-chan
//

import Foundation

/// What a screen should be showing right now.
enum ViewState<Content> {
    case loading
    case content(Content)
    /// Loaded successfully, but there is nothing to show.
    case empty(String)
    case failure(String)
}

extension ViewState {

    /// The loaded value, if any. Handy for view models that need to read back
    /// what they last published without duplicating it in another property.
    var content: Content? {
        guard case .content(let content) = self else { return nil }
        return content
    }
}
