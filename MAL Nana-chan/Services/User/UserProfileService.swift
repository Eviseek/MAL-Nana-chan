//
//  UserProfileService.swift
//  MAL Nana-chan
//

import Foundation

/// Reads the signed-in user's profile.
protocol UserProfileServicing: AnyObject {
    func myProfile(completion: @escaping (Result<User, APIError>) -> Void)
}

final class UserProfileService: UserProfileServicing {

    private let apiClient: APIClienting

    init(apiClient: APIClienting) {
        self.apiClient = apiClient
    }

    func myProfile(completion: @escaping (Result<User, APIError>) -> Void) {
        apiClient.fetch(MALEndpoint.myProfile(), as: User.self, completion: completion)
    }
}
