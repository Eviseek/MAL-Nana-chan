//
//  MoreInformation.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.08.2023.
//

import Foundation

struct AnimeMoreInformation: Codable {
    let data: AnimeInformation?
}

struct AnimeInformation: Codable {
    var producers: [JikanObject]?
    var licensors: [JikanObject]?
    var studios: [JikanObject]?
}

struct JikanObject: Codable {
    var name: String
    var url: String
}
