//
//  SkeletonPresenter.swift
//  MAL Nana-chan
//

import UIKit
@preconcurrency import SkeletonView

/// Shows and hides SkeletonView's shimmer placeholders.
///
/// `@MainActor` because every call touches a `UIView`.
@MainActor
enum SkeletonPresenter {

    static func show(on view: UIView) {
        let gradient = SkeletonGradient(baseColor: .silver, secondaryColor: .asbestos)
        view.showAnimatedGradientSkeleton(usingGradient: gradient)
    }

    static func hide(on view: UIView) {
        view.hideSkeleton(transition: .crossDissolve(0.25))
    }
}
