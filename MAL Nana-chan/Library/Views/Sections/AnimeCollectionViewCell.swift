//
//  AnimeCollectionViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// Poster tile for an anime, used by every horizontal strip.
final class AnimeCollectionViewCell: UICollectionViewCell, ReusableCell {

    @IBOutlet private weak var animeImageView: UIImageView!
    @IBOutlet private weak var animeTitleLabel: UILabel!
    @IBOutlet private weak var animeScoreLabel: UILabel!
    @IBOutlet private weak var animeTypeView: UIView!
    @IBOutlet private weak var animeTypeLabel: UILabel!

    // Declared because the nib connects them. The tile is actually sized by the
    // flow layout via `Layout.MediaCell`, so nothing reads these — but removing
    // the outlets would leave the nib pointing at properties that no longer
    // exist, which fails KVC at load time and crashes.
    @IBOutlet private weak var cellHeight: NSLayoutConstraint!
    @IBOutlet private weak var cellWidth: NSLayoutConstraint!

    func configure(with preview: MediaPreview) {
        animeTitleLabel.text = preview.title
        animeScoreLabel.text = preview.scoreText
        animeImageView.setRemoteImage(preview.imageURL)

        // Shown only for related titles, where MAL supplies "Sequel", "Prequel"…
        animeTypeLabel.text = preview.relationText
        animeTypeView.isHidden = preview.relationText == nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        animeImageView.setRemoteImage(nil)
    }
}
