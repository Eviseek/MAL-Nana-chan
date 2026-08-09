//
//  GenreCollectionViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// A genre pill on the detail screens.
final class GenreCollectionViewCell: UICollectionViewCell, ReusableCell {

    @IBOutlet private weak var genreView: UIView!
    @IBOutlet private weak var genreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // UIKit always calls this on the main thread, but `awakeFromNib` is
        // inherited from `NSObject` as nonisolated, so an override can't be
        // main-actor-isolated and the compiler can't see the guarantee.
        MainActor.assumeIsolated {
            genreView.round(Layout.CornerRadius.medium)
        }
    }

    func configure(name: String) {
        genreLabel.text = name
    }
}
