//
//  Response.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

struct Response: Codable {
    var data: [Node]
    var paging: Paging?
}

struct Node: Codable {
    var node: Anime
}

struct Paging: Codable {
    var previous: String?
    var next: String?
}
