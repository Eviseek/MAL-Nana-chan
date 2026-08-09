//
//  HomeViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// One row of the Home table.
enum HomeRow {
    case trailer(videoID: String)
    case section(MediaSection)
}

/// Drives the Home screen: a trailer (when Jikan is up) and three anime rows.
final class HomeViewModel {

    private let animeService: AnimeServicing
    private let discoveryService: DiscoveryServicing
    private let reachability: ReachabilityObserving

    private(set) var state: ViewState<[HomeRow]> = .loading {
        didSet { onStateChange?(state) }
    }

    /// The view controller's single render hook.
    var onStateChange: ((ViewState<[HomeRow]>) -> Void)?

    init(
        animeService: AnimeServicing,
        discoveryService: DiscoveryServicing,
        reachability: ReachabilityObserving
    ) {
        self.animeService = animeService
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

    // MARK: - Loading

    private func load() {
        state = .loading

        let group = DispatchGroup()

        // Each request writes into its own slot, so a failure in one leaves the
        // others intact.
        var sections: [MediaSection?] = Array(repeating: nil, count: Request.allCases.count)
        var firstError: APIError?
        var trailerVideoID: String?

        for request in Request.allCases {
            group.enter()
            fetch(request) { result in
                switch result {
                case .success(let page):
                    sections[request.rawValue] = MediaSection(title: request.title, page: page, kind: .anime)
                case .failure(let error):
                    firstError = firstError ?? error
                }
                group.leave()
            }
        }

        // The trailer comes from Jikan, a third party. It can't be allowed to
        // fail the screen, so its result is optional rather than a `Result`.
        group.enter()
        discoveryService.featuredTrailerID { videoID in
            trailerVideoID = videoID
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.apply(sections: sections.compactMap { $0 }, trailerVideoID: trailerVideoID, error: firstError)
        }
    }

    private func apply(sections: [MediaSection], trailerVideoID: String?, error: APIError?) {
        guard !sections.isEmpty else {
            state = .failure(error?.userMessage ?? Strings.Common.noDescription)
            return
        }

        var rows: [HomeRow] = []
        if let trailerVideoID {
            rows.append(.trailer(videoID: trailerVideoID))
        }
        rows.append(contentsOf: sections.map(HomeRow.section))

        state = .content(rows)
    }

    /// Reloads only when there is nothing on screen, so a reconnect while the
    /// user is reading doesn't yank the content out from under them.
    private func reloadIfEmpty() {
        guard state.content == nil else { return }
        load()
    }

    // MARK: - The rows this screen asks for

    /// `rawValue` doubles as the slot index in the results array above.
    private enum Request: Int, CaseIterable {
        case currentSeason
        case upcomingSeason
        case popular

        var title: String {
            switch self {
            case .currentSeason: return Strings.Home.currentSeason
            case .upcomingSeason: return Strings.Home.upcomingSeason
            case .popular: return Strings.Home.popularAnime
            }
        }
    }

    private func fetch(_ request: Request, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        switch request {
        case .currentSeason:
            animeService.seasonalAnime(season: .current, year: Season.currentYear, completion: completion)
        case .upcomingSeason:
            let upcoming = Season.upcoming
            animeService.seasonalAnime(season: upcoming.season, year: upcoming.year, completion: completion)
        case .popular:
            animeService.popularAnime(completion: completion)
        }
    }
}
