//
//  AnimePreviewTableViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// Full-width anime row used by search results and "see all".
final class AnimePreviewTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var episodesNumberLabel: UILabel!
    @IBOutlet private weak var episodesTitleLabel: UILabel!
    @IBOutlet private weak var typeContainerView: UIView!
    @IBOutlet private weak var myListView: UIView!
    @IBOutlet private weak var myListButton: UIButton!

    /// Called when the user taps the "my list" chip.
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
        episodesNumberLabel.text = preview.unitCountText
        episodesTitleLabel.text = preview.unitName
        itemImageView.setRemoteImage(preview.imageURL)

        // Hidden when signed out: the sheet it opens can only write to a
        // signed-in user's list. This used to be read from a global
        // `TokenHandler.isUserLoggedIn` inside `awakeFromNib`, which is called
        // once per cell *creation* — so cells recycled after a sign-in kept the
        // chip hidden until the list scrolled far enough to build new ones.
        myListView.isHidden = !canEditList
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.setRemoteImage(nil)
        onMyListTapped = nil
    }

    @IBAction private func myListClicked(_ sender: UIButton) {
        onMyListTapped?()
    }
}
