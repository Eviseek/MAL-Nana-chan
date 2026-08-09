//
//  MangaCollectionViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// Poster tile for a manga.
final class MangaCollectionViewCell: UICollectionViewCell, ReusableCell {

    @IBOutlet private weak var mangaImageView: UIImageView!
    @IBOutlet private weak var mangaTitleLabel: UILabel!
    @IBOutlet private weak var mangaScoreLabel: UILabel!
    @IBOutlet private weak var mangaTypeView: UIView!
    @IBOutlet private weak var mangaTypeLabel: UILabel!

    // Connected by the nib but unused — see `AnimeCollectionViewCell`.
    @IBOutlet private weak var cellHeight: NSLayoutConstraint!
    @IBOutlet private weak var cellWidth: NSLayoutConstraint!

    func configure(with preview: MediaPreview) {
        mangaTitleLabel.text = preview.title
        mangaScoreLabel.text = preview.scoreText
        mangaImageView.setRemoteImage(preview.imageURL)

        mangaTypeLabel.text = preview.relationText
        mangaTypeView.isHidden = preview.relationText == nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mangaImageView.setRemoteImage(nil)
    }
}
