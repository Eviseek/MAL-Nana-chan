//
//  Layout.swift
//  MAL Nana-chan
//

import CoreGraphics

/// Sizes and spacings that more than one view relies on.
enum Layout {

    enum MediaCell {
        static let width: CGFloat = 130
        static let height: CGFloat = 240
    }

    enum CornerRadius {
        static let small: CGFloat = 5
        static let medium: CGFloat = 8
        static let large: CGFloat = 10
    }

    /// Collapsed height of the synopsis text view on the detail screens.
    static let collapsedSynopsisHeight: CGFloat = 150

    /// How close to the bottom of a list the user has to scroll before the next
    /// page is requested.
    static let paginationTriggerDistance: CGFloat = 100

    enum ActivityIndicator {
        static let size: CGFloat = 50
    }

    enum Score {
        static let minimum: Float = 0
        static let maximum: Float = 10
    }
}
