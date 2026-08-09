//
//  NSAttributtedString+Extensions.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 09.08.2026.
//

import Foundation

extension NSAttributedString {

    /// A `", "`-separated run of links.
    convenience init(linksFor entities: [JikanEntity]) {
        let joined = NSMutableAttributedString()

        for (index, entity) in entities.enumerated() {
            let attributed = NSMutableAttributedString(string: entity.name)
            if let url = URL(string: entity.url) {
                attributed.addAttribute(.link, value: url, range: NSRange(location: 0, length: entity.name.count))
            }
            joined.append(attributed)

            if index < entities.count - 1 {
                joined.append(NSAttributedString(string: ", "))
            }
        }

        self.init(attributedString: joined)
    }
}
