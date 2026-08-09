//
//  UIButton+Extensions.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 09.08.2026.
//

import UIKit

extension UIButton {

    /// Swaps a button between the selected and unselected list-status looks.
    func setStatusSelected(_ isSelected: Bool) {
        backgroundColor = isSelected ? .mal : .systemGray5
        tintColor = isSelected ? .white : .mal
    }
}
