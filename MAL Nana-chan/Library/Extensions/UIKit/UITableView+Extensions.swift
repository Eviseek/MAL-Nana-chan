//
//  UI+Extensions.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 09.08.2026.
//

import UIKit

extension UITableView {

    func register<Cell: UITableViewCell & ReusableCell>(_ cellType: Cell.Type) {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    /// Dequeues a cell of the requested type.
    ///
    /// Traps rather than returning an optional: a wrong or unregistered
    /// identifier is a wiring mistake that will reproduce on the first launch,
    /// not a runtime condition worth recovering from. The old `if let … as?`
    /// dance silently returned a blank `UITableViewCell()` instead, which is far
    /// harder to diagnose than a crash pointing at the line.
    func dequeue<Cell: UITableViewCell & ReusableCell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("\(cellType.reuseIdentifier) is not registered on this table view.")
        }
        return cell
    }
}
