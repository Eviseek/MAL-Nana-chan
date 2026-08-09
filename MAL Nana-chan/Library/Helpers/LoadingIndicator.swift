//
//  LoadingIndicator.swift
//  MAL Nana-chan
//

import UIKit
import NVActivityIndicatorView

/// A full-screen spinner owned by the view it covers.
@MainActor
final class LoadingIndicator {

    private let indicatorView: NVActivityIndicatorView
    private let overlay = UIView()

    init() {
        indicatorView = NVActivityIndicatorView(
            frame: CGRect(origin: .zero, size: CGSize(width: Layout.ActivityIndicator.size,
                                                      height: Layout.ActivityIndicator.size)),
            type: .lineScalePulseOut,
            color: .mal
        )
    }

    func start(in view: UIView, background: UIColor? = nil) {
        guard overlay.superview == nil else { return }

        overlay.backgroundColor = background ?? view.backgroundColor
        overlay.frame = view.bounds
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlay)

        indicatorView.center = CGPoint(x: overlay.bounds.midX, y: overlay.bounds.midY)
        indicatorView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
                                          .flexibleLeftMargin, .flexibleRightMargin]
        overlay.addSubview(indicatorView)
        indicatorView.startAnimating()
    }

    func stop() {
        indicatorView.stopAnimating()
        overlay.removeFromSuperview()
    }
}
