//
//  HomeViewController.swift
//  MAL Nana-chan
//

import UIKit

/// The Home tab: a trailer and a few curated anime rows.
final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorMsgLabel: UILabel!

    /// Injected by `AppCoordinator` before the window goes up. Implicitly
    /// unwrapped because a storyboard scene can't take initialiser arguments —
    /// the alternative is an optional every method has to unwrap, which hides a
    /// wiring mistake instead of failing at it.
    var viewModel: HomeViewModel!
    var coordinator: MediaCoordinator?

    private let loadingIndicator = LoadingIndicator()
    private var rows: [HomeRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        bindViewModel()
        viewModel.onViewDidLoad()
    }

    private func setUpTableView() {
        tableView.register(AnimeSectionTableViewCell.self)
        tableView.register(YoutubeEmbedTableViewCell.self)
        tableView.dataSource = self
    }

    /// Renders whatever state the view model publishes.
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
    }

    private func render(_ state: ViewState<[HomeRow]>) {
        switch state {
        case .loading:
            loadingIndicator.start(in: view)
            errorMsgLabel.isHidden = true

        case .content(let rows):
            loadingIndicator.stop()
            self.rows = rows
            errorMsgLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()

        case .empty(let message), .failure(let message):
            loadingIndicator.stop()
            rows = []
            errorMsgLabel.isHidden = false
            errorMsgLabel.text = message
            tableView.isHidden = true
        }
    }

    @IBAction private func fetchDataAgainClicked(_ sender: UIButton) {
        viewModel.onRetryTapped()
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .trailer(let videoID):
            let cell = tableView.dequeue(YoutubeEmbedTableViewCell.self, for: indexPath)
            cell.configure(videoID: videoID)
            return cell

        case .section(let section):
            let cell = tableView.dequeue(AnimeSectionTableViewCell.self, for: indexPath)
            cell.configure(with: section)
            cell.onSelectItem = { [weak self] preview in
                self?.coordinator?.showDetail(for: preview)
            }
            cell.onSeeAll = { [weak self] in
                self?.coordinator?.showSeeAll(section: section)
            }
            return cell
        }
    }
}
