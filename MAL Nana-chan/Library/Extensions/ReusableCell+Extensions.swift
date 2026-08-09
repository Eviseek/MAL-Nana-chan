//
//  ReusableCell.swift
//  MAL Nana-chan
//

import UIKit

protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
    /// `@MainActor` because `UINib.init(nibName:bundle:)` is. The only callers are
    /// the `register` helpers below, which live on `UITableView`/`UICollectionView`
    /// and are therefore main-actor-isolated already, so this costs nothing.
    @MainActor static var nib: UINib { get }
}

extension ReusableCell {
    static var reuseIdentifier: String { String(describing: self) }

    @MainActor
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: .main) }
}
