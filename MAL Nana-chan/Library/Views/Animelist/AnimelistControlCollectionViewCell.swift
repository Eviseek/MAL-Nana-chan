//
//  AnimelistControlCollectionViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// One tab of the status filter strip above the user's anime list.
final class AnimelistControlCollectionViewCell: UICollectionViewCell, ReusableCell {

    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var selectedLineView: UIView!

    func configure(title: String, isSelected: Bool) {
        statusLabel.text = title
        // The weight is derived from the nib's point size rather than a constant,
        // so changing the label in Interface Builder still works.
        statusLabel.font = .systemFont(ofSize: statusLabel.font.pointSize, weight: isSelected ? .bold : .regular)
        selectedLineView.isHidden = !isSelected
    }
}
