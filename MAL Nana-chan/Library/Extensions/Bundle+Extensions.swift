//
//  Bundle+Extensions.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 09.08.2026.
//

import Foundation

extension Bundle {

    /// Reads a build-time configuration value out of Info.plist.
    ///
    /// The chain is: `Config/Secrets.xcconfig` (git-ignored) defines a build
    /// setting → `Config/App.xcconfig` includes it → Info.plist references it as
    /// `$(MAL_CLIENT_ID)` → Xcode substitutes it at build time → this reads it
    /// back. Nothing secret ends up in source, and rotating a value is a config
    /// change rather than a code change.
    ///
    /// Traps when the value is missing rather than returning an empty string. A
    /// fresh clone without `Secrets.xcconfig` would otherwise send an empty client
    /// id and fail every request with an opaque 403 — this says exactly what to do
    /// instead, on the first launch.
    func requiredConfigurationValue(_ key: ConfigurationKey) -> String {
        guard
            let value = object(forInfoDictionaryKey: key.rawValue) as? String,
            !value.isEmpty,
            // An unsubstituted `$(…)` means the build setting was never defined.
            !value.hasPrefix("$(")
        else {
            fatalError(
                """
                Missing configuration value '\(key.rawValue)'.

                Copy Config/Secrets.example.xcconfig to Config/Secrets.xcconfig and \
                fill in your MyAnimeList client id from https://myanimelist.net/apiconfig
                """
            )
        }
        return value
    }

    /// Info.plist keys that come from the build configuration.
    enum ConfigurationKey: String {
        case malClientID = "MALClientID"
    }
}
