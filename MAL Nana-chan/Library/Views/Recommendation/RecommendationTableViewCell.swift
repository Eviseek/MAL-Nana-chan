//
//  RecommendationTableViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// A "if you liked this, try that" pair on the Explore screen.
final class RecommendationTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var leftRecImageView: UIImageView!
    @IBOutlet private weak var leftRecTitleLabel: UILabel!
    @IBOutlet private weak var rightRecImageView: UIImageView!
    @IBOutlet private weak var rightRecTitleLabel: UILabel!

    // Jikan's recommendation feed carries neither a score nor a type, so these
    // four keep whatever the nib put in them. They are still declared because the
    // nib connects them, and a nib outlet with no matching property crashes at
    // load.
    @IBOutlet private weak var leftRecScoreLabel: UILabel!
    @IBOutlet private weak var leftRecTypeLabel: UILabel!
    @IBOutlet private weak var rightRecScoreLabel: UILabel!
    @IBOutlet private weak var rightRecTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // UIKit always calls this on the main thread, but `awakeFromNib` is
        // inherited from `NSObject` as nonisolated, so an override can't be
        // main-actor-isolated and the compiler can't see the guarantee.
        MainActor.assumeIsolated {
            selectionStyle = .none
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
    }

    func configure(with pair: (left: RecommendationEntry, right: RecommendationEntry)) {
        leftRecTitleLabel.text = pair.left.title
        leftRecImageView.setRemoteImage(pair.left.images.jpg.imageUrl)

        rightRecTitleLabel.text = pair.right.title
        rightRecImageView.setRemoteImage(pair.right.images.jpg.imageUrl)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        leftRecImageView.setRemoteImage(nil)
        rightRecImageView.setRemoteImage(nil)
    }
}
