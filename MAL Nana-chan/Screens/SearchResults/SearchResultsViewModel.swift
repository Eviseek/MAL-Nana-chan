//
//  SearchResultsViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// Drives the search results screen for one query, across both media types.
final class SearchResultsViewModel {

    private static let minimumQueryLength = 3

    private let animeService: AnimeServicing
    private let mangaService: MangaServicing
    private let recentSearches: RecentSearchesStoring

    /// Whether the "my list" chip on each row should be offered.
    let canEditList: Bool

    private(set) var query: String
    private(set) var selectedType: ItemType = .anime

    /// Results are kept per type, so flipping the segmented control back shows
    /// what was already loaded (including any extra pages).
    private var results: [ItemType: MediaPage] = [:]
    private var isLoadingPage = false

    private(set) var state: ViewState<[MediaPreview]> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<[MediaPreview]>) -> Void)?
    var onShowMessage: ((String) -> Void)?
    var onOpenMedia: ((MediaPreview) -> Void)?
    var onOpenListSheet: ((MediaListTarget) -> Void)?

    init(
        query: String,
        animeService: AnimeServicing,
        mangaService: MangaServicing,
        recentSearches: RecentSearchesStoring,
        canEditList: Bool
    ) {
        self.query = query
        self.animeService = animeService
        self.mangaService = mangaService
        self.recentSearches = recentSearches
        self.canEditList = canEditList
    }

    var items: [MediaPreview] { results[selectedType]?.items ?? [] }

    func onViewDidLoad() {
        runSearch()
    }

    func select(type: ItemType) {
        guard type != selectedType else { return }
        selectedType = type

        // Already loaded once — just show it again.
        if let cached = results[type] {
            state = cached.items.isEmpty ? .empty(Strings.Common.notAvailable) : .content(cached.items)
            return
        }
        runSearch()
    }

    func search(query: String?) {
        let trimmed = query?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard trimmed.count >= Self.minimumQueryLength else {
            onShowMessage?(Strings.Explore.queryTooShort)
            return
        }

        self.query = trimmed
        // A new query invalidates both types' results, not just the visible one.
        results.removeAll()
        runSearch()
    }

    func selectItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        onOpenMedia?(items[index])
    }

    func openListSheet(for preview: MediaPreview) {
        onOpenListSheet?(preview.listTarget)
    }

    // MARK: - Loading

    private func runSearch() {
        state = .loading
        recentSearches.add(query)

        let type = selectedType
        fetchFirstPage(for: type) { [weak self] result in
            guard let self, self.selectedType == type else { return }

            switch result {
            case .success(let page):
                self.results[type] = page
                self.state = page.items.isEmpty
                    ? .empty("Nothing found for “\(self.query)”.")
                    : .content(page.items)

            case .failure(let error):
                self.state = .failure(error.userMessage)
            }
        }
    }

    /// Appends the next page, if there is one and we aren't already fetching.
    func loadMoreIfNeeded() {
        guard
            !isLoadingPage,
            let current = results[selectedType],
            let nextPageURL = current.nextPageURL
        else {
            return
        }

        isLoadingPage = true
        let type = selectedType

        fetchPage(url: nextPageURL, for: type) { [weak self] result in
            guard let self else { return }
            self.isLoadingPage = false

            guard case .success(let page) = result, self.selectedType == type else { return }

            var updated = self.results[type] ?? .empty
            updated.items.append(contentsOf: page.items)
            updated.nextPageURL = page.nextPageURL
            self.results[type] = updated
            self.state = .content(updated.items)
        }
    }

    private func fetchFirstPage(for type: ItemType, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        switch type {
        case .anime: animeService.search(query: query, completion: completion)
        case .manga: mangaService.search(query: query, completion: completion)
        }
    }

    private func fetchPage(
        url: String,
        for type: ItemType,
        completion: @escaping (Result<MediaPage, APIError>) -> Void
    ) {
        switch type {
        case .anime: animeService.page(url: url, completion: completion)
        case .manga: mangaService.page(url: url, completion: completion)
        }
    }
}
