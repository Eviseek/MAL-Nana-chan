//
//  RecentSearchesStore.swift
//  MAL Nana-chan
//

import Foundation

/// Remembers what the user searched for.
protocol RecentSearchesStoring: AnyObject {

    /// Most recent first.
    var searches: [String] { get }

    func add(_ query: String)

    /// Drops the whole list if it is older than `recentSearchesLifetime`.
    func purgeExpired()
}

/// `UserDefaults`-backed `RecentSearchesStoring`.
final class RecentSearchesStore: RecentSearchesStoring {

    private let defaults: UserDefaults
    private let lifetime: TimeInterval

    init(defaults: UserDefaults = .standard, lifetime: TimeInterval = AppConfiguration.recentSearchesLifetime) {
        self.defaults = defaults
        self.lifetime = lifetime
    }

    var searches: [String] {
        defaults.stringArray(forKey: StorageKey.Defaults.recentSearches) ?? []
    }

    /// Re-searching an existing term moves it back to the top instead of being
    /// ignored. The old code appended to the end and skipped duplicates outright,
    /// so the list read oldest-first and the term you just used stayed buried.
    func add(_ query: String) {
        var updated = searches.filter { $0.caseInsensitiveCompare(query) != .orderedSame }
        updated.insert(query, at: 0)

        defaults.set(updated, forKey: StorageKey.Defaults.recentSearches)
        defaults.set(Date(), forKey: StorageKey.Defaults.recentSearchesSavedAt)
    }

    func purgeExpired() {
        guard let savedAt = defaults.object(forKey: StorageKey.Defaults.recentSearchesSavedAt) as? Date else {
            return
        }
        guard Date().timeIntervalSince(savedAt) >= lifetime else { return }

        defaults.removeObject(forKey: StorageKey.Defaults.recentSearches)
        defaults.removeObject(forKey: StorageKey.Defaults.recentSearchesSavedAt)
    }
}
