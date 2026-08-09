//
//  ThemeTableViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// One opening or ending theme credit line.
final class ThemeTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var themeTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // UIKit always calls this on the main thread, but `awakeFromNib` is
        // inherited from `NSObject` as nonisolated, so an override can't be
        // main-actor-isolated and the compiler can't see the guarantee.
        MainActor.assumeIsolated {
            selectionStyle = .none
        }
    }

    func configure(title: String) {
        themeTitleLabel.text = title
    }
}
