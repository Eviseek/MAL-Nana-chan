//
//  MangaSectionTableViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// A titled row of manga posters with a "see all" button.
/// The manga twin of `AnimeSectionTableViewCell` — separate because it has its
/// own nib and its own poster cell.
final class MangaSectionTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var sectionNameLabel: UILabel!
    @IBOutlet private weak var sectionSeeAllButton: UIButton!
    @IBOutlet private weak var sectionCollectionView: UICollectionView!
    @IBOutlet private weak var sectionCollectionViewHeight: NSLayoutConstraint!

    private var items: [MediaPreview] = []

    var onSelectItem: ((MediaPreview) -> Void)?
    var onSeeAll: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // UIKit always calls this on the main thread, but `awakeFromNib` is
        // inherited from `NSObject` as nonisolated, so an override can't be
        // main-actor-isolated and the compiler can't see the guarantee.
        MainActor.assumeIsolated {
            sectionSeeAllButton.round()
            sectionCollectionViewHeight.constant = Layout.MediaCell.height

            sectionCollectionView.register(MangaCollectionViewCell.self)
            sectionCollectionView.dataSource = self
            sectionCollectionView.delegate = self
        }
    }

    func configure(with section: MediaSection, showsSeeAll: Bool = true) {
        sectionNameLabel.text = section.title
        sectionSeeAllButton.isHidden = !showsSeeAll
        items = section.items
        sectionCollectionView.reloadData()
        sectionCollectionView.setContentOffset(.zero, animated: false)
    }

    @IBAction private func seeAllButtonClicked(_ sender: UIButton) {
        onSeeAll?()
    }
}

extension MangaSectionTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MangaCollectionViewCell.self, for: indexPath)
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

extension MangaSectionTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: Layout.MediaCell.width, height: Layout.MediaCell.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(items[indexPath.item])
    }
}
