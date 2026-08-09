//
//  MangaPreviewTableViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// Full-width manga row used by search results and "see all".
final class MangaPreviewTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var mangaImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var chaptersNumberLabel: UILabel!
    @IBOutlet private weak var chaptersTextLabel: UILabel!
    @IBOutlet private weak var typeContainerView: UIView!
    @IBOutlet private weak var myListView: UIView!
    @IBOutlet private weak var myListButton: UIButton!

    var onMyListTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // UIKit always calls this on the main thread, but `awakeFromNib` is
        // inherited from `NSObject` as nonisolated, so an override can't be
        // main-actor-isolated and the compiler can't see the guarantee.
        MainActor.assumeIsolated {
            selectionStyle = .none
            typeContainerView.round()
            myListView.applyListChipStyle()
        }
    }

    func configure(with preview: MediaPreview, canEditList: Bool) {
        titleLabel.text = preview.title
        scoreLabel.text = preview.scoreText
        typeLabel.text = preview.typeText
        seasonLabel.text = preview.seasonText
        chaptersNumberLabel.text = preview.unitCountText
        chaptersTextLabel.text = preview.unitName
        mangaImageView.setRemoteImage(preview.imageURL)
        myListView.isHidden = !canEditList
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mangaImageView.setRemoteImage(nil)
        onMyListTapped = nil
    }

    @IBAction private func myListClicked(_ sender: UIButton) {
        onMyListTapped?()
    }
}
