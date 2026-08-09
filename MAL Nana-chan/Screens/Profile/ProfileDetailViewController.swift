//
//  ProfileDetailViewController.swift
//  MAL Nana-chan
//

import UIKit

/// The signed-in user's MAL profile.
final class ProfileDetailViewController: UIViewController {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var joinedAtLabel: UILabel!

    var viewModel: ProfileDetailViewModel!

    private let loadingIndicator = LoadingIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onViewDidLoad()
    }

    /// The avatar is rounded here, not in `viewDidLoad`.
    ///
    /// In `viewDidLoad` the view still has its storyboard frame, so
    /// `frame.width / 2` used the design-time width. On any device where layout
    /// resolved to a different size, the "circle" came out as a rounded rectangle.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImageView.makeCircular()
    }

    private func render(_ state: ViewState<ProfileContent>) {
        switch state {
        case .loading:
            loadingIndicator.start(in: view)

        case .content(let profile):
            loadingIndicator.stop()
            usernameLabel.text = profile.name
            genderLabel.text = profile.gender
            birthdayLabel.text = profile.birthday
            joinedAtLabel.text = profile.joinedAt
            userImageView.setRemoteImage(profile.pictureURL)

        case .empty(let message), .failure(let message):
            loadingIndicator.stop()
            showErrorDialog(message: message)
        }
    }

    @IBAction private func appSettingsButtonClicked(_ sender: UIButton) {
        // Intentionally empty — there is no settings screen yet. The button is
        // wired in the storyboard, so the action has to exist.
    }

    @IBAction private func logOutButtonClicked(_ sender: UIButton) {
        viewModel.signOut()
    }
}
