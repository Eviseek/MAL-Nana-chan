//
//  ThemesDetailViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// Which half of the themes list is showing.
enum ThemeKind {
    case openings
    case endings
}

/// Drives the opening/ending themes screen.
final class ThemesDetailViewModel {

    private let animeID: Int
    private let discoveryService: DiscoveryServicing
    private let reachability: ReachabilityObserving

    private var themes: ThemeSongs?
    private(set) var selectedKind: ThemeKind = .openings

    private(set) var state: ViewState<[String]> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<[String]>) -> Void)?
    /// A YouTube search URL for the tapped theme.
    var onOpenURL: ((URL) -> Void)?

    init(animeID: Int, discoveryService: DiscoveryServicing, reachability: ReachabilityObserving) {
        self.animeID = animeID
        self.discoveryService = discoveryService
        self.reachability = reachability
    }

    func onViewDidLoad() {
        reachability.addObserver(self) { [weak self] in
            self?.reloadIfEmpty()
        }
        load()
    }

    func onRetryTapped() {
        load()
    }

    func select(kind: ThemeKind) {
        selectedKind = kind
        publish()
    }

    func selectTheme(at index: Int) {
        let titles = currentTitles
        guard titles.indices.contains(index) else { return }

        // A theme credit is free text like "1: Butter-Fly by Kouji Wada", so the
        // only useful action is to search for it. Encoded with the query encoder
        // rather than `.urlHostAllowed`, which the old code used — that set leaves
        // `&` and `+` intact and truncated any title containing them.
        var components = URLComponents(string: AppConfiguration.youtubeSearchURL)
        components?.percentEncodedQuery = QueryEncoding.string(from: [("search_query", titles[index])])

        guard let url = components?.url else { return }
        onOpenURL?(url)
    }

    // MARK: - Loading

    private func load() {
        state = .loading

        // Read from `/anime/{id}/full`, which still works, rather than from
        // `/anime/{id}/themes`, which answers 504. The old screen skipped the
        // request altogether and showed a hardcoded "temporarily unavailable"
        // message; the data was available all along, one endpoint over.
        discoveryService.themeSongs(animeID: animeID) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let themes):
                self.themes = themes
                self.publish()
            case .failure:
                self.state = .empty(Strings.Themes.unavailable)
            }
        }
    }

    private func reloadIfEmpty() {
        guard themes == nil else { return }
        load()
    }

    private func publish() {
        let titles = currentTitles
        state = titles.isEmpty ? .empty(Strings.Themes.unavailable) : .content(titles)
    }

    private var currentTitles: [String] {
        switch selectedKind {
        case .openings: return themes?.openings ?? []
        case .endings: return themes?.endings ?? []
        }
    }
}
