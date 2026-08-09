//
//  Recommendation.swift
//  MAL Nana-chan
//

import Foundation

/// A user-written "if you liked X, try Y" pair from Jikan.
struct Recommendation: Codable, Sendable {
    let entry: [RecommendationEntry]
    let content: String?
}

extension Recommendation {

    /// The two titles being compared, or `nil` if Jikan sent a malformed pair.
    var pair: (left: RecommendationEntry, right: RecommendationEntry)? {
        guard entry.count >= 2 else { return nil }
        return (entry[0], entry[1])
    }
}

struct RecommendationEntry: Codable, Sendable {
    let id: Int
    let url: String
    let images: RecommendationImages
    let title: String

    private enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case url
        case images
        case title
    }
}

struct RecommendationImages: Codable, Sendable {
    let jpg: RecommendationImageURL
    let webp: RecommendationImageURL?
}

struct RecommendationImageURL: Codable, Sendable {
    let imageUrl: String

    private enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
}
