//
//  LoginViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Sign in with MyAnimeList.
final class LoginViewController: UIViewController {

    @IBOutlet private weak var loginButton: UIButton!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.round(Layout.CornerRadius.large)

        viewModel.onShowMessage = { [weak self] message in
            self?.showErrorDialog(message: message)
        }
    }

    @IBAction private func loginButtonClicked(_ sender: UIButton) {
        viewModel.signIn(from: self)
    }
}
