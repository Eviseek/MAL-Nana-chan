//
//  ExploreViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// One row of the Explore table.
enum ExploreRow {
    case popularManga(MediaSection)
    case recommendation(Recommendation)
}

/// Drives the Explore tab: popular manga, community recommendations, and the
/// search entry point.
final class ExploreViewModel {

    /// How many recommendations the list shows.
    private static let recommendationLimit = 10

    /// The shortest query MAL's search will accept usefully.
    private static let minimumQueryLength = 3

    private let mangaService: MangaServicing
    private let discoveryService: DiscoveryServicing
    private let recentSearches: RecentSearchesStoring
    private let reachability: ReachabilityObserving

    private(set) var state: ViewState<[ExploreRow]> = .loading {
        didSet { onStateChange?(state) }
    }

    private(set) var recentSearchQueries: [String] = []

    var onStateChange: ((ViewState<[ExploreRow]>) -> Void)?
    var onRecentSearchesChange: (() -> Void)?
    /// A message to show without changing the screen's state — currently only
    /// "your query is too short".
    var onShowMessage: ((String) -> Void)?
    var onOpenSearchResults: ((String) -> Void)?
    var onOpenRecommendation: ((Recommendation) -> Void)?

    init(
        mangaService: MangaServicing,
        discoveryService: DiscoveryServicing,
        recentSearches: RecentSearchesStoring,
        reachability: ReachabilityObserving
    ) {
        self.mangaService = mangaService
        self.discoveryService = discoveryService
        self.recentSearches = recentSearches
        self.reachability = reachability
    }

    func onViewDidLoad() {
        recentSearches.purgeExpired()
        refreshRecentSearches()

        reachability.addObserver(self) { [weak self] in
            self?.reloadIfEmpty()
        }
        load()
    }

    /// Recent searches can change on another screen (the results screen saves the
    /// query it ran), so they are re-read every time this tab comes back.
    func onViewDidAppear() {
        refreshRecentSearches()
    }

    func onRetryTapped() {
        load()
    }

    // MARK: - Search

    func search(query: String?) {
        let trimmed = query?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard trimmed.count >= Self.minimumQueryLength else {
            onShowMessage?(Strings.Explore.queryTooShort)
            return
        }

        recentSearches.add(trimmed)
        refreshRecentSearches()
        onOpenSearchResults?(trimmed)
    }

    func selectRecentSearch(at index: Int) {
        guard recentSearchQueries.indices.contains(index) else { return }
        search(query: recentSearchQueries[index])
    }

    // MARK: - Selection

    func selectRow(at index: Int) {
        guard case .content(let rows) = state, rows.indices.contains(index) else { return }

        switch rows[index] {
        case .recommendation(let recommendation):
            onOpenRecommendation?(recommendation)
        case .popularManga:
            // Taps inside the poster strip are reported by the cell itself.
            break
        }
    }

    // MARK: - Loading

    private func load() {
        state = .loading

        let group = DispatchGroup()
        var popularManga: MediaSection?
        var recommendations: [Recommendation] = []
        var firstError: APIError?

        group.enter()
        mangaService.favouriteManga { result in
            switch result {
            case .success(let page):
                popularManga = MediaSection(title: Strings.Explore.popularManga, page: page, kind: .manga)
            case .failure(let error):
                firstError = firstError ?? error
            }
            group.leave()
        }

        group.enter()
        discoveryService.animeRecommendations { result in
            switch result {
            case .success(let loaded):
                recommendations = loaded
            case .failure(let error):
                firstError = firstError ?? error
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.apply(popularManga: popularManga, recommendations: recommendations, error: firstError)
        }
    }

    private func apply(popularManga: MediaSection?, recommendations: [Recommendation], error: APIError?) {
        var rows: [ExploreRow] = []

        if let popularManga {
            rows.append(.popularManga(popularManga))
        }

        // Malformed pairs are dropped here rather than being handed to a cell
        // that would have to index into a possibly-short array.
        rows.append(contentsOf: recommendations
            .filter { $0.pair != nil }
            .prefix(Self.recommendationLimit)
            .map(ExploreRow.recommendation))

        guard !rows.isEmpty else {
            state = .failure(error?.userMessage ?? Strings.Common.noDescription)
            return
        }
        state = .content(rows)
    }

    private func reloadIfEmpty() {
        guard state.content == nil else { return }
        load()
    }

    private func refreshRecentSearches() {
        recentSearchQueries = recentSearches.searches
        onRecentSearchesChange?()
    }
}
