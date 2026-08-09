//
//  RecommendationDetailViewController.swift
//  MAL Nana-chan
//

import UIKit

/// One community recommendation: the two titles and the write-up.
///
/// Deliberately has no view model. There is no network call, no state and no
/// formatting — everything it shows is already in the value the coordinator hands
/// it.
final class RecommendationDetailViewController: UIViewController {

    @IBOutlet private weak var leftRecImageView: UIImageView!
    @IBOutlet private weak var leftRecTitleLabel: UILabel!
    @IBOutlet private weak var leftRecScoreLabel: UILabel!
    @IBOutlet private weak var leftRecTypeLabel: UILabel!

    @IBOutlet private weak var rightRecImageView: UIImageView!
    @IBOutlet private weak var rightRecTitleLabel: UILabel!
    @IBOutlet private weak var rightRecScoreLabel: UILabel!
    @IBOutlet private weak var rightRecTypeLabel: UILabel!

    @IBOutlet private weak var recTextView: UITextView!

    var recommendation: Recommendation?
    /// Pre-unwrapped by the coordinator, which won't open this screen for a
    /// malformed pair.
    var pair: (left: RecommendationEntry, right: RecommendationEntry)?
    var coordinator: MediaCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let pair else { return }

        leftRecTitleLabel.text = pair.left.title
        leftRecImageView.setRemoteImage(pair.left.images.jpg.imageUrl)

        rightRecTitleLabel.text = pair.right.title
        rightRecImageView.setRemoteImage(pair.right.images.jpg.imageUrl)

        recTextView.text = recommendation?.content
    }

    @IBAction private func leftRecSelected(_ sender: UIButton) {
        open(pair?.left)
    }

    @IBAction private func rightRecSeletec(_ sender: UIButton) {
        open(pair?.right)
    }

    /// Jikan's anime recommendation feed only ever pairs anime, so both sides open
    /// the anime detail screen.
    private func open(_ entry: RecommendationEntry?) {
        guard let entry else { return }
        coordinator?.showAnimeDetail(id: entry.id)
    }
}
