//
//  ProfileDetailViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// The signed-in user's profile, formatted for display.
struct ProfileContent {
    let name: String
    let pictureURL: String?
    let gender: String
    let birthday: String
    let joinedAt: String
}

/// Drives the profile screen.
final class ProfileDetailViewModel {

    private let userProfileService: UserProfileServicing
    private let authentication: AuthenticationServicing

    private(set) var state: ViewState<ProfileContent> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<ProfileContent>) -> Void)?
    var onSignedOut: (() -> Void)?

    init(userProfileService: UserProfileServicing, authentication: AuthenticationServicing) {
        self.userProfileService = userProfileService
        self.authentication = authentication
    }

    func onViewDidLoad() {
        load()
    }

    func signOut() {
        authentication.signOut()
        onSignedOut?()
    }

    private func load() {
        state = .loading

        userProfileService.myProfile { [weak self] result in
            switch result {
            case .success(let user):
                self?.state = .content(Self.content(from: user))
            case .failure(let error):
                self?.state = .failure(error.userMessage)
            }
        }
    }

    private static func content(from user: User) -> ProfileContent {
        ProfileContent(
            name: user.name,
            pictureURL: user.picture,
            gender: user.gender ?? Strings.Common.notSpecified,
            birthday: user.birthday?.readableAPIDay ?? Strings.Common.notSpecified,
            joinedAt: user.joinedAt.readableAPITimestamp
        )
    }
}
