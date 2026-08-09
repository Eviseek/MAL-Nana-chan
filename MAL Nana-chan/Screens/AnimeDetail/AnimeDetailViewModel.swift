//
//  AnimeDetailViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// Everything the anime detail screen displays, already formatted.
struct AnimeDetailContent {
    let title: String
    let imageURL: String?
    let scoreText: String
    let typeText: String?
    let statusText: String?
    let episodesText: String
    let durationText: String
    let seasonText: String?
    let synopsis: String
    let synonymsText: String?
    let englishTitle: String?
    let japaneseTitle: String?
    let genres: [String]
    let relatedAnime: [MediaPreview]
    let relatedManga: [MediaPreview]
    let recommendations: [MediaPreview]
    let listTarget: MediaListTarget
}

/// Drives the anime detail screen.
final class AnimeDetailViewModel {

    private let animeID: Int
    private let animeService: AnimeServicing
    private let reachability: ReachabilityObserving

    /// Whether the "add to my list" button should be offered at all.
    let isSignedIn: Bool

    private(set) var state: ViewState<AnimeDetailContent> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<AnimeDetailContent>) -> Void)?
    var onOpenMedia: ((MediaPreview) -> Void)?
    var onOpenThemes: ((Int) -> Void)?
    var onOpenCredits: ((Int) -> Void)?
    var onOpenListSheet: ((MediaListTarget) -> Void)?

    init(
        animeID: Int,
        animeService: AnimeServicing,
        reachability: ReachabilityObserving,
        isSignedIn: Bool
    ) {
        self.animeID = animeID
        self.animeService = animeService
        self.reachability = reachability
        self.isSignedIn = isSignedIn
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

    func openThemes() {
        onOpenThemes?(animeID)
    }

    func openCredits() {
        onOpenCredits?(animeID)
    }

    func openListSheet() {
        guard let target = state.content?.listTarget else { return }
        onOpenListSheet?(target)
    }

    func select(_ preview: MediaPreview) {
        onOpenMedia?(preview)
    }

    // MARK: - Loading

    private func load() {
        state = .loading

        animeService.anime(id: animeID) { [weak self] result in
            switch result {
            case .success(let anime):
                self?.state = .content(Self.content(from: anime))
            case .failure(let error):
                self?.state = .failure(error.userMessage)
            }
        }
    }

    private func reloadIfEmpty() {
        guard state.content == nil else { return }
        load()
    }

    private static func content(from anime: Anime) -> AnimeDetailContent {
        AnimeDetailContent(
            title: anime.title,
            imageURL: anime.mainPicture?.medium,
            scoreText: anime.score?.description ?? Strings.Common.notAvailable,
            typeText: anime.mediaType?.displayName,
            statusText: anime.status?.displayName,
            episodesText: anime.episodesCount.map(String.init) ?? Strings.Common.notAvailable,
            // MAL reports 0 for unknown, which the old screen printed as "0".
            durationText: anime.episodeDurationMinutes.map { "\($0) min" } ?? Strings.Common.notAvailable,
            seasonText: anime.startSeason?.displayName,
            synopsis: anime.synopsis?.isEmpty == false ? anime.synopsis! : Strings.Detail.noSynopsis,
            synonymsText: anime.synonymsText,
            englishTitle: anime.alternativeTitles?.en?.nilIfEmpty,
            japaneseTitle: anime.alternativeTitles?.ja?.nilIfEmpty,
            genres: anime.genres?.map(\.name) ?? [],
            relatedAnime: anime.relatedAnime?.map(\.preview) ?? [],
            relatedManga: anime.relatedManga?.map(\.preview) ?? [],
            recommendations: anime.recommendations?.map(\.preview) ?? [],
            listTarget: anime.listTarget
        )
    }
}
