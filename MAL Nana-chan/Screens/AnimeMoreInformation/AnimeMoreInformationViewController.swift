//
//  AnimeMoreInformationViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Studios, producers and licensors for one anime, each linking to MAL.
final class AnimeMoreInformationViewController: UIViewController {

    @IBOutlet private weak var studiosTextView: UITextView!
    @IBOutlet private weak var producersTextView: UITextView!
    @IBOutlet private weak var licensorsTextView: UITextView!

    @IBOutlet private weak var studiosView: UIView!
    @IBOutlet private weak var producersView: UIView!
    @IBOutlet private weak var licensorsView: UIView!

    var viewModel: AnimeMoreInformationViewModel!

    private let loadingIndicator = LoadingIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        [studiosTextView, producersTextView, licensorsTextView].forEach { $0?.configureAsLinkList() }

        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onViewDidLoad()
    }

    private func render(_ state: ViewState<AnimeDetails>) {
        switch state {
        case .loading:
            loadingIndicator.start(in: view)

        case .content(let details):
            loadingIndicator.stop()
            studiosTextView.setLinks(details.studios)
            producersTextView.setLinks(details.producers)
            licensorsTextView.setLinks(details.licensors)

        case .empty(let message), .failure(let message):
            loadingIndicator.stop()
            showErrorDialog(message: message)
        }
    }
}
