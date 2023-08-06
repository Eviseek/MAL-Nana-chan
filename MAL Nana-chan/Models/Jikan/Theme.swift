//
//  Theme.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.08.2023.
//

import Foundation

struct Theme: Codable {
    let data: Themes?
}

struct Themes: Codable {
    var openings: [String]?
    var endings: [String]?
}
