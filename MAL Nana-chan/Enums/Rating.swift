//
//  Rating.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum Rating: String, Codable {
    case g = "G - All Ages"
    case pg = "PG - Children"
    case pg_13 = "Teens 13 and Older"
    case r = "R 17+ (violence & profanity)"
  //  case r+ = "R+ - Profanity & Nudity"
    case rx = "Rx - Hentai"
}
