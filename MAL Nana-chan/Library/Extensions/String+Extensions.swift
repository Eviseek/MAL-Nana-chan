//
//  String+Extensions.swift
//  MAL Nana-chan
//

import Foundation

extension String {

    /// Parses a day-precision API date, e.g. `"1998-04-03"`.
    var apiDay: Date? {
        try? Date(self, strategy: APIDate.day)
    }

    /// Parses a full API timestamp, e.g. `"2023-07-06T19:32:11+00:00"`.
    var apiTimestamp: Date? {
        try? Date(self, strategy: APIDate.timestamp)
    }

    /// A day-precision API date, reformatted for the user in their locale.
    ///
    /// Named properties rather than the old `readableDate(from: .apiDay)`: passing
    /// a format token around meant every call site had to know which of the three
    /// formats its string was in, and getting it wrong failed silently. Now the
    /// property name states it.
    var readableAPIDay: String {
        apiDay.map { $0.formatted(APIDate.readable) } ?? Strings.Common.notSpecified
    }

    /// A full API timestamp, reformatted for the user in their locale.
    var readableAPITimestamp: String {
        apiTimestamp.map { $0.formatted(APIDate.readable) } ?? Strings.Common.notSpecified
    }

    /// The anime season a day-precision API date falls in, e.g. `"Spring 1998"`.
    func season() -> String {
        guard let date = apiDay else { return Strings.Detail.unknownSeason }

        let components = Calendar.current.dateComponents([.year, .month], from: date)
        guard let month = components.month, let year = components.year else {
            return Strings.Detail.unknownSeason
        }

        return "\(Season(month: month).displayName) \(year)"
    }
}

extension String {

    /// `nil` for an empty string, so a missing value and a blank one behave the
    /// same at the call site.
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
