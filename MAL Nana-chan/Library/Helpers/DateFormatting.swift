//
//  DateFormatting.swift
//  MAL Nana-chan
//

import Foundation

enum APIDate {

    /// Day-precision API dates, e.g. `"1998-04-03"`.
    static let day = Date.ParseStrategy(
        format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
        locale: Locale(identifier: "en_US_POSIX"),
        timeZone: .gmt
    )

    static let timestamp = Date.ISO8601FormatStyle()

    /// How a date is shown to a person.
    ///
    /// Deliberately *not* pinned to a locale, unlike the two above: this one should
    /// follow the device, so a Czech user reads "3. 4. 1998".
    static let readable = Date.FormatStyle.dateTime.day().month(.abbreviated).year()
}
