//
//  SeeAllViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// Drives the full, paginated version of a Home/Explore section.
final class SeeAllViewModel {

    private let animeService: AnimeServicing
    private let mangaService: MangaServicing

    let title: String
    let kind: ItemType
    let canEditList: Bool

    private var items: [MediaPreview]
    private var nextPageURL: String?
    private var isLoadingPage = false

    private(set) var state: ViewState<[MediaPreview]> {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<[MediaPreview]>) -> Void)?
    var onOpenMedia: ((MediaPreview) -> Void)?
    var onOpenListSheet: ((MediaListTarget) -> Void)?

    init(section: MediaSection, animeService: AnimeServicing, mangaService: MangaServicing, canEditList: Bool) {
        self.title = section.title
        self.kind = section.kind
        self.items = section.items
        self.nextPageURL = section.nextPageURL
        self.animeService = animeService
        self.mangaService = mangaService
        self.canEditList = canEditList
        self.state = section.items.isEmpty
            ? .empty(Strings.Common.notAvailable)
            : .content(section.items)
    }

    func selectItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        onOpenMedia?(items[index])
    }

    func openListSheet(for preview: MediaPreview) {
        onOpenListSheet?(preview.listTarget)
    }

    func loadMoreIfNeeded() {
        guard !isLoadingPage, let nextPageURL else { return }

        isLoadingPage = true
        fetchPage(url: nextPageURL) { [weak self] result in
            guard let self else { return }
            self.isLoadingPage = false

            guard case .success(let page) = result else { return }
            self.items.append(contentsOf: page.items)
            self.nextPageURL = page.nextPageURL
            self.state = .content(self.items)
        }
    }

    private func fetchPage(url: String, completion: @escaping (Result<MediaPage, APIError>) -> Void) {
        switch kind {
        case .anime: animeService.page(url: url, completion: completion)
        case .manga: mangaService.page(url: url, completion: completion)
        }
    }
}
