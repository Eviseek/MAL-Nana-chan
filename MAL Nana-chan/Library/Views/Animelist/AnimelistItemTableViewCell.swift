//
//  AnimelistItemTableViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// A row of the signed-in user's anime list: the title plus their own entry.
final class AnimelistItemTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    @IBOutlet private weak var itemTypeLabel: UILabel!
    @IBOutlet private weak var itemScoreLabel: UILabel!
    @IBOutlet private weak var itemSeasonLabel: UILabel!
    @IBOutlet private weak var itemStatusLabel: UILabel!

    @IBOutlet private weak var itemListStatusLabel: UILabel!
    @IBOutlet private weak var itemListScoreLabel: UILabel!
    @IBOutlet private weak var itemListProgressLabel: UILabel!
    @IBOutlet private weak var itemListPriorityLabel: UILabel!

    @IBOutlet private weak var myListView: UIView!

    var onMyListTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // UIKit always calls this on the main thread, but `awakeFromNib` is
        // inherited from `NSObject` as nonisolated, so an override can't be
        // main-actor-isolated and the compiler can't see the guarantee.
        MainActor.assumeIsolated {
            selectionStyle = .none
            myListView.round()
        }
    }

    func configure(with row: AnimelistRow) {
        let preview = row.preview

        itemTitleLabel.text = preview.title
        itemTypeLabel.text = preview.typeText
        itemScoreLabel.text = preview.scoreText
        itemSeasonLabel.text = preview.seasonText
        itemStatusLabel.text = preview.statusText
        itemImageView.setRemoteImage(preview.imageURL)

        itemListStatusLabel.text = row.statusText
        itemListScoreLabel.text = row.scoreText
        itemListProgressLabel.text = row.progressText
        itemListPriorityLabel.text = row.priorityText
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.setRemoteImage(nil)
        onMyListTapped = nil
    }

    @IBAction private func listButtonClicked(_ sender: UIButton) {
        onMyListTapped?()
    }
}
