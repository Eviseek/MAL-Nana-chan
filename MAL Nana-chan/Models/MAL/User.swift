//
//  User.swift
//  MAL Nana-chan
//

import Foundation

/// The signed-in user's profile (`/users/@me`).
struct User: Codable, Sendable {
    let id: Int
    let name: String
    let picture: String?
    let gender: String?
    /// Day precision, e.g. `"1998-04-03"`.
    let birthday: String?
    /// Full timestamp.
    let joinedAt: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
        case gender
        case birthday
        case joinedAt = "joined_at"
    }
}
