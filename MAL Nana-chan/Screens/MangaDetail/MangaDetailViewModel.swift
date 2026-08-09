//
//  MangaDetailViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// Everything the manga detail screen displays, already formatted.
struct MangaDetailContent {
    let title: String
    let imageURL: String?
    let scoreText: String
    let typeText: String?
    let statusText: String?
    let volumesText: String
    let chaptersText: String
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

/// Drives the manga detail screen.
final class MangaDetailViewModel {

    private let mangaID: Int
    private let mangaService: MangaServicing
    private let reachability: ReachabilityObserving

    let isSignedIn: Bool

    private(set) var state: ViewState<MangaDetailContent> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<MangaDetailContent>) -> Void)?
    var onOpenMedia: ((MediaPreview) -> Void)?
    var onOpenCredits: ((Int) -> Void)?
    var onOpenListSheet: ((MediaListTarget) -> Void)?

    init(
        mangaID: Int,
        mangaService: MangaServicing,
        reachability: ReachabilityObserving,
        isSignedIn: Bool
    ) {
        self.mangaID = mangaID
        self.mangaService = mangaService
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

    func openCredits() {
        onOpenCredits?(mangaID)
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

        mangaService.manga(id: mangaID) { [weak self] result in
            switch result {
            case .success(let manga):
                self?.state = .content(Self.content(from: manga))
            case .failure(let error):
                self?.state = .failure(error.userMessage)
            }
        }
    }

    private func reloadIfEmpty() {
        guard state.content == nil else { return }
        load()
    }

    private static func content(from manga: Manga) -> MangaDetailContent {
        MangaDetailContent(
            title: manga.title,
            imageURL: manga.mainPicture?.medium,
            scoreText: manga.score?.description ?? Strings.Common.notAvailable,
            typeText: manga.mediaType?.displayName,
            statusText: manga.status?.displayName,
            volumesText: manga.volumesCount.map(String.init) ?? Strings.Common.notAvailable,
            chaptersText: manga.chaptersCount.map(String.init) ?? Strings.Common.notAvailable,
            synopsis: manga.synopsis?.nilIfEmpty ?? Strings.Detail.noSynopsis,
            synonymsText: manga.synonymsText,
            englishTitle: manga.alternativeTitles?.en?.nilIfEmpty,
            japaneseTitle: manga.alternativeTitles?.ja?.nilIfEmpty,
            genres: manga.genres?.map(\.name) ?? [],
            relatedAnime: manga.relatedAnime?.map(\.preview) ?? [],
            relatedManga: manga.relatedManga?.map(\.preview) ?? [],
            recommendations: manga.recommendations?.map(\.preview) ?? [],
            listTarget: manga.listTarget
        )
    }
}
