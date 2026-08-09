//
//  AssetColor.swift
//  MAL Nana-chan
//

import UIKit

/// Colours defined in `Assets.xcassets`.
enum AssetColor: String {
    case mal = "mal_color"
    case malBlue = "MAL Blue color"
}

extension UIColor {

    /// The asset colour, or `.label` if the asset is missing.
    ///
    /// A visible fallback beats `nil`: a control tinted `.label` looks wrong in
    /// review, whereas a `nil` tint looks like a layout bug somewhere else.
    static func asset(_ color: AssetColor) -> UIColor {
        UIColor(named: color.rawValue) ?? .label
    }

    static var mal: UIColor { .asset(.mal) }
}
