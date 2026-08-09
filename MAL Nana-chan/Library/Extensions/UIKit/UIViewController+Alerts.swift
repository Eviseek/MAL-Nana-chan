//
//  UIViewController+Alerts.swift
//  MAL Nana-chan
//

import UIKit

extension UIViewController {

    /// A one-button alert for anything the user needs to acknowledge.
    ///
    /// The old version passed a handler that called `self.dismiss(animated:)`.
    /// That was redundant — tapping any action dismisses the alert itself — and
    /// actively risky, because if the screen was presenting something else by
    /// then, `dismiss` would tear *that* down instead.
    func showErrorDialog(message: String, title: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Common.dismiss, style: .default))
        present(alert, animated: true)
    }

    /// A brief, self-dismissing message.
    func showToast(message: String, seconds: TimeInterval = 1.5) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = Layout.CornerRadius.large
        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak alert] in
            alert?.dismiss(animated: true)
        }
    }
}
