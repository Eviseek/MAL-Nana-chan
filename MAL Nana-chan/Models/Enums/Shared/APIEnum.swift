//
//  APIEnum.swift
//  MAL Nana-chan
//

import Foundation

/// An enum whose raw value comes straight off a MyAnimeList response.
///
/// MyAnimeList ships new values before documenting them. `tv_special` is the
/// clearest example: the live API returns it for ~6% of anime, but it is still
/// absent from the published API reference. The same is true of `web_novel`,
/// `mixed_media` and `light_novel` for manga.
///
/// A plain `RawRepresentable & Decodable` enum throws `DecodingError.dataCorrupted`
/// for any value it doesn't recognise. Because `Response.data` is an *array*,
/// `JSONDecoder` aborts the whole array on the first bad element — so one
/// unrecognised anime blanks the entire screen rather than one label.
///
/// Conforming to `APIEnum` swaps that for a fallback: an unknown raw value
/// decodes to `unknownValue`. The cost of MAL inventing a new value drops from
/// "the page fails to load" to "one field reads as Unknown".
///
/// Deliberately *not* used for `UserAnimeStatus` / `UserMangaStatus`: those are
/// written back to the user's list, and silently coercing an unrecognised status
/// into a real one would corrupt their data. There, failing loudly is correct.
protocol APIEnum: RawRepresentable, Codable where RawValue: Codable {

    /// Returned when the API sends a raw value this build doesn't know about.
    static var unknownValue: Self { get }
}

extension APIEnum {

    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(RawValue.self)
        self = Self(rawValue: rawValue) ?? Self.unknownValue
    }
}
