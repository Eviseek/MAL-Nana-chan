//
//  MangaMoreInformation.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 07.08.2023.
//

import Foundation

struct MangaMoreInformation: Codable {
    let data: MangaInformation?
}

struct MangaInformation: Codable {
    var authors: [JikanObject]?
    var serializations: [JikanObject]?
    var demographics: [JikanObject]?
}
