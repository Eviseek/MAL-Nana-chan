//
//  TokenStore.swift
//  MAL Nana-chan
//

import Foundation
import KeychainAccess

/// Keeps the user's access token and answers "is anyone signed in?".
protocol TokenStoring: AnyObject {

    /// The stored token, or `nil` if there isn't one or it has expired.
    var accessToken: String? { get }

    var isSignedIn: Bool { get }

    func save(token: String, expiresAt: Date?)
    func clear()
}

/// Keychain-backed `TokenStoring`.
final class KeychainTokenStore: TokenStoring {

    private let keychain: Keychain

    init(service: String = AppConfiguration.keychainService) {
        keychain = Keychain(service: service)
    }

    /// Checked on every read, not once at launch.
    var accessToken: String? {
        guard !hasExpired else {
            clear()
            return nil
        }
        return keychain[StorageKey.Keychain.accessToken]
    }

    var isSignedIn: Bool { accessToken != nil }

    func save(token: String, expiresAt: Date?) {
        keychain[StorageKey.Keychain.accessToken] = token
        keychain[StorageKey.Keychain.tokenExpiration] = expiresAt?.apiTimestampString
    }

    func clear() {
        try? keychain.remove(StorageKey.Keychain.accessToken)
        try? keychain.remove(StorageKey.Keychain.tokenExpiration)
    }

    /// `false` when there is no recorded expiry — MAL tokens are long-lived and a
    /// missing date shouldn't sign a working session out.
    private var hasExpired: Bool {
        guard
            let stored = try? keychain.get(StorageKey.Keychain.tokenExpiration),
            let expiry = stored.apiTimestamp
        else {
            return false
        }
        return Date() >= expiry
    }
}
