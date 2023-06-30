//
//  Recommendation.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 25.06.2023.
//

import Foundation


struct Recommendation: Codable {
    let data: [RecommendationData]
    let pagination: Pagination?
}

struct RecommendationData: Codable {
    var entry: [RecEntry] 
    var content: String?
}

struct RecEntry: Codable {
    var id: Int
    var url: String
    var images: RecImages
    var title: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case url = "url"
        case images = "images"
        case title = "title"
    }
    
}

struct RecImages: Codable {
    var jpg: JpgRecImages
    var webp: WebpRecImages
}

struct JpgRecImages: Codable {
    var imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
    
}

struct WebpRecImages: Codable {
    var imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
    
}
