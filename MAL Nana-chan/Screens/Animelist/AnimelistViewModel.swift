//
//  AnimelistViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// What the animelist screen is showing.
///
/// "Signed out" is a first-class state here rather than a separate boolean,
/// because it is genuinely exclusive with the other four.
enum AnimelistState {
    case signedOut
    case loading
    case content([AnimelistRow])
    case empty(String)
    case failure(String)
}

/// Drives the user's own anime list, with a status filter strip and paging.
final class AnimelistViewModel {

    private let animeService: AnimeServicing
    private let tokenStore: TokenStoring
    private let reachability: ReachabilityObserving

    let filters = AnimelistFilter.all

    /// The selection is one index, not a flag on each filter.
    ///
    /// `SelectableView.isSelected` spread the answer across six values, and
    /// changing tabs meant looping to find the previously selected one before
    /// flipping both. With an index there is nothing to keep in sync.
    private(set) var selectedFilterIndex = 0

    private var rows: [AnimelistRow] = []
    private var nextPageURL: String?
    private var isLoadingPage = false

    private(set) var state: AnimelistState = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((AnimelistState) -> Void)?
    var onFiltersChange: (() -> Void)?
    var onOpenMedia: ((MediaPreview) -> Void)?
    var onOpenListSheet: ((MediaListTarget) -> Void)?
    var onRequestSignIn: (() -> Void)?

    init(animeService: AnimeServicing, tokenStore: TokenStoring, reachability: ReachabilityObserving) {
        self.animeService = animeService
        self.tokenStore = tokenStore
        self.reachability = reachability
    }

    func onViewDidLoad() {
        reachability.addObserver(self) { [weak self] in
            self?.reloadIfEmpty()
        }
    }

    /// Re-checked on every appearance, because the user can sign in or out on
    /// another screen while this tab is off-screen.
    func onViewWillAppear() {
        guard tokenStore.isSignedIn else {
            rows = []
            nextPageURL = nil
            state = .signedOut
            return
        }
        if rows.isEmpty {
            load()
        }
    }

    func onRetryTapped() {
        load()
    }

    func onSignInTapped() {
        onRequestSignIn?()
    }

    /// Called after a successful sign-in or a list edit.
    func reload() {
        rows = []
        nextPageURL = nil
        load()
    }

    // MARK: - Filtering

    func selectFilter(at index: Int) {
        guard filters.indices.contains(index), index != selectedFilterIndex else { return }
        selectedFilterIndex = index
        onFiltersChange?()
        reload()
    }

    // MARK: - Rows

    func selectRow(at index: Int) {
        guard rows.indices.contains(index) else { return }
        onOpenMedia?(rows[index].preview)
    }

    func openListSheet(for row: AnimelistRow) {
        onOpenListSheet?(row.preview.listTarget)
    }

    // MARK: - Loading

    private func load() {
        guard !isLoadingPage else { return }

        isLoadingPage = true
        state = .loading

        animeService.myAnimelist(status: filters[selectedFilterIndex].status) { [weak self] result in
            self?.isLoadingPage = false
            self?.handleFirstPage(result)
        }
    }

    private func handleFirstPage(_ result: Result<AnimelistPage, APIError>) {
        switch result {
        case .success(let page):
            rows = page.rows
            nextPageURL = page.nextPageURL
            state = page.rows.isEmpty ? .empty(Strings.Animelist.empty) : .content(page.rows)
        case .failure(let error):
            state = .failure(error.userMessage)
        }
    }

    func loadMoreIfNeeded() {
        guard !isLoadingPage, let nextPageURL else { return }

        isLoadingPage = true
        animeService.myAnimelistPage(url: nextPageURL) { [weak self] result in
            guard let self else { return }
            self.isLoadingPage = false

            guard case .success(let page) = result else { return }
            self.rows.append(contentsOf: page.rows)
            self.nextPageURL = page.nextPageURL
            self.state = .content(self.rows)
        }
    }

    private func reloadIfEmpty() {
        guard tokenStore.isSignedIn, rows.isEmpty else { return }
        load()
    }
}
