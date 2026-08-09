//
//  MangaStatus.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 25.03.2023.
//

import Foundation

enum MangaStatus: String, APIEnum {

    case unknown
    case finished
    case currently_publishing
    case not_yet_published
    // Returned by the live API but missing from MAL's published documentation.
    case on_hiatus
    case discontinued

    static let unknownValue = MangaStatus.unknown

    var displayName: String {
        switch self {
        case .unknown: return "Unknown"
        case .finished: return "Finished"
        case .currently_publishing: return "Currently Publishing"
        case .not_yet_published: return "Not Yet Published"
        case .on_hiatus: return "On Hiatus"
        case .discontinued: return "Discontinued"
        }
    }

}
