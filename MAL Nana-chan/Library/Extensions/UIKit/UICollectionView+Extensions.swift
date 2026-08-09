//
//  UICollectionView+Extensions.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 09.08.2026.
//

import UIKit

extension UICollectionView {

    func register<Cell: UICollectionViewCell & ReusableCell>(_ cellType: Cell.Type) {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeue<Cell: UICollectionViewCell & ReusableCell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("\(cellType.reuseIdentifier) is not registered on this collection view.")
        }
        return cell
    }
}
