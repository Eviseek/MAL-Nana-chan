//
//  Response.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

struct Response<T: Codable>: Codable {
    var data: [Node<T>]
    var paging: Paging?
}

struct Node<T: Codable>: Codable {
    var node: T
    var relation_type_formatted: String?
    var num_recommendations: Int?
}

struct Paging: Codable {
    var previous: String?
    var next: String?
}
