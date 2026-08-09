//
//  Response.swift
//  MAL Nana-chan
//

import Foundation

/// MAL's envelope for every collection endpoint.
struct Response<Value: Codable & Sendable>: Codable, Sendable {
    var data: [Node<Value>]
    var paging: Paging?
}

/// One element of a MAL collection.
///
/// MAL wraps each item in an object so it can hang relationship metadata off it
/// — the same anime appears as `{ "node": {…}, "relation_type_formatted": "Sequel" }`
/// in a related list and as `{ "node": {…} }` in a search result.
struct Node<Value: Codable & Sendable>: Codable, Sendable {
    var node: Value
    var relationTypeFormatted: String?
    var recommendationCount: Int?

    private enum CodingKeys: String, CodingKey {
        case node
        case relationTypeFormatted = "relation_type_formatted"
        case recommendationCount = "num_recommendations"
    }
}

/// Cursor links. `next` is a complete, already-encoded URL.
struct Paging: Codable, Sendable {
    var previous: String?
    var next: String?
}
