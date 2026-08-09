//
//  AnimeSource.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum AnimeSource: String, APIEnum {

    case other
    case original
    case manga
    case web_manga
    case digital_manga
    case novel
    case light_novel
    case visual_novel
    case game
    case card_game
    case book
    case picture_book
    case radio
    case music
    // Returned by the live API but missing from MAL's published documentation.
    case four_koma_manga = "4_koma_manga"
    case web_novel
    case mixed_media

    /// MAL already defines `other` for "none of the above", so an unrecognised
    /// value folds into it rather than adding a second unknown-ish case.
    static let unknownValue = AnimeSource.other

}
