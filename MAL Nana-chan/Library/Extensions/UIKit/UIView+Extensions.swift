//
//  UIView+Extensions.swift
//  MAL Nana-chan
//

import UIKit

extension UIView {

    func round(_ radius: CGFloat = Layout.CornerRadius.small) {
        layer.cornerRadius = radius
    }

    /// The MAL-tinted outline used around the "my list" chips.
    func applyListChipStyle() {
        round()
        layer.borderWidth = 1
        layer.borderColor = UIColor.mal.cgColor
    }

    /// Turns the view into a circle. Call from `layoutSubviews` or after the
    /// frame is final — reading `bounds` in `awakeFromNib` (what the profile
    /// screen used to do) uses the nib's placeholder size, so the "circle" came
    /// out as a rounded rectangle on any device whose layout differed.
    func makeCircular() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        clipsToBounds = true
    }
}
