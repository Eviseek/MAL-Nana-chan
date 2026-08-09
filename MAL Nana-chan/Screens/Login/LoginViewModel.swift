//
//  LoginViewModel.swift
//  MAL Nana-chan
//

import UIKit

/// Drives the sign-in screen.
final class LoginViewModel {

    private let authentication: AuthenticationServicing

    var onSignedIn: (() -> Void)?
    var onShowMessage: ((String) -> Void)?

    init(authentication: AuthenticationServicing) {
        self.authentication = authentication
    }

    /// Needs the presenting view controller because MAL's sign-in is a web flow
    /// that has to be presented from somewhere.
    ///
    /// This is the one place a `UIViewController` legitimately crosses into a view
    /// model, and it is passed in per call rather than stored — the view model
    /// doesn't hold on to it afterwards.
    func signIn(from presenter: UIViewController) {
        authentication.signIn(from: presenter) { [weak self] result in
            switch result {
            case .success:
                self?.onSignedIn?()
            case .failure(let error):
                self?.onShowMessage?(error.userMessage)
            }
        }
    }
}
