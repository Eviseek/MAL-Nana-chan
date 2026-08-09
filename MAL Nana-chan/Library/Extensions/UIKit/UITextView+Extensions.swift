//
//  UITextView+Extensions.swift
//  MAL Nana-chan
//

import UIKit

extension UITextView {

    /// Turns the text view into a read-only list of tappable links.
    ///
    /// Both "more information" screens configured three text views each with the
    /// same six lines, then built the attributed string with the same nine-line
    /// loop — six copies of the same code across two files.
    func configureAsLinkList() {
        isEditable = false
        isScrollEnabled = false
        isUserInteractionEnabled = true
        linkTextAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }

    /// Shows the entities as a comma-separated list of links to their MAL pages.
    func setLinks(_ entities: [JikanEntity]?) {
        guard let entities, !entities.isEmpty else {
            text = Strings.Common.notSpecified
            return
        }
        attributedText = NSAttributedString(linksFor: entities)
    }
}
