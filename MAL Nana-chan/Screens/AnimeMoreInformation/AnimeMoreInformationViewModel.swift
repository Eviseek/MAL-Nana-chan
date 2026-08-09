//
//  AnimeMoreInformationViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// Drives the anime production-credits screen.
final class AnimeMoreInformationViewModel {

    private let animeID: Int
    private let discoveryService: DiscoveryServicing

    private(set) var state: ViewState<AnimeDetails> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<AnimeDetails>) -> Void)?

    init(animeID: Int, discoveryService: DiscoveryServicing) {
        self.animeID = animeID
        self.discoveryService = discoveryService
    }

    func onViewDidLoad() {
        load()
    }

    private func load() {
        state = .loading

        discoveryService.animeCredits(animeID: animeID) { [weak self] result in
            switch result {
            case .success(let details):
                self?.state = .content(details)
            case .failure(let error):
                self?.state = .failure(error.userMessage)
            }
        }
    }
}
