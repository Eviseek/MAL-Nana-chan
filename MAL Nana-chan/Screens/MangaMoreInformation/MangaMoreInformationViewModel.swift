//
//  MangaMoreInformationViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// Drives the manga credits screen.
final class MangaMoreInformationViewModel {

    private let mangaID: Int
    private let discoveryService: DiscoveryServicing

    private(set) var state: ViewState<MangaDetails> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<MangaDetails>) -> Void)?

    init(mangaID: Int, discoveryService: DiscoveryServicing) {
        self.mangaID = mangaID
        self.discoveryService = discoveryService
    }

    func onViewDidLoad() {
        load()
    }

    private func load() {
        state = .loading

        discoveryService.mangaCredits(mangaID: mangaID) { [weak self] result in
            switch result {
            case .success(let details):
                self?.state = .content(details)
            case .failure(let error):
                self?.state = .failure(error.userMessage)
            }
        }
    }
}
