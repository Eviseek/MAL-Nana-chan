//
//  MangaMoreInformationViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Authors, serialisations and demographics for one manga.
final class MangaMoreInformationViewController: UIViewController {

    @IBOutlet private weak var authorsTextView: UITextView!
    @IBOutlet private weak var serializationsTextView: UITextView!
    @IBOutlet private weak var demographicsTextView: UITextView!

    var viewModel: MangaMoreInformationViewModel!

    private let loadingIndicator = LoadingIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        [authorsTextView, serializationsTextView, demographicsTextView].forEach { $0?.configureAsLinkList() }

        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onViewDidLoad()
    }

    private func render(_ state: ViewState<MangaDetails>) {
        switch state {
        case .loading:
            loadingIndicator.start(in: view)

        case .content(let details):
            loadingIndicator.stop()
            authorsTextView.setLinks(details.authors)
            serializationsTextView.setLinks(details.serializations)
            demographicsTextView.setLinks(details.demographics)

        case .empty(let message), .failure(let message):
            loadingIndicator.stop()
            showErrorDialog(message: message)
        }
    }
}
