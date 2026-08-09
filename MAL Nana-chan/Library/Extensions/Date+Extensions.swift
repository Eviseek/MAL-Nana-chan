//
//  Date+Extensions.swift
//  MAL Nana-chan
//

import Foundation

extension Date {

    /// The API timestamp form, used when writing the token expiry to the keychain.
    ///
    /// Round-trips with `String.apiTimestamp`, which is the only thing that reads
    /// it back.
    var apiTimestampString: String {
        formatted(APIDate.timestamp)
    }
}
