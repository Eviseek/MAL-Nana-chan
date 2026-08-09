//
//  RecentSearchesTableViewCell.swift
//  MAL Nana-chan
//

import UIKit

/// One previously used search term.
final class RecentSearchesTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var rsTitleLabel: UILabel!

    func configure(query: String) {
        rsTitleLabel.text = query
    }
}
