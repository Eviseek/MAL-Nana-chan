//
//  UIScrollView+Extensions.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 09.08.2026.
//

import UIKit

extension UIScrollView {

    /// Whether the user has scrolled close enough to the bottom that the next
    /// page should be requested.
    var isNearBottom: Bool {
        let distanceFromBottom = contentSize.height - frame.height - contentOffset.y
        return distanceFromBottom < Layout.paginationTriggerDistance
    }
}
