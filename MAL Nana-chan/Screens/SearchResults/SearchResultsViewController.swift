//
//  SearchResultsViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Search results, with a segmented control to switch between anime and manga.
final class SearchResultsViewController: UIViewController {

    @IBOutlet private weak var animeResultsTableView: UITableView!
    @IBOutlet private weak var mangaResultsTableView: UITableView!
    @IBOutlet private weak var noResultsLabel: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: SearchResultsViewModel!
    var coordinator: MediaCoordinator?

    private let loadingIndicator = LoadingIndicator()
    private var items: [MediaPreview] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableViews()
        searchBar.text = viewModel.query
        searchBar.delegate = self

        bindViewModel()
        viewModel.onViewDidLoad()
    }

    private func setUpTableViews() {
        animeResultsTableView.register(AnimePreviewTableViewCell.self)
        animeResultsTableView.dataSource = self
        animeResultsTableView.delegate = self

        mangaResultsTableView.register(MangaPreviewTableViewCell.self)
        mangaResultsTableView.dataSource = self
        mangaResultsTableView.delegate = self
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onShowMessage = { [weak self] message in
            self?.showErrorDialog(message: message, title: Strings.Common.error)
        }
        viewModel.onOpenMedia = { [weak self] preview in
            self?.coordinator?.showDetail(for: preview)
        }
        viewModel.onOpenListSheet = { [weak self] target in
            self?.coordinator?.presentListSheet(for: target)
        }
    }

    private func render(_ state: ViewState<[MediaPreview]>) {
        switch state {
        case .loading:
            loadingIndicator.start(in: view)
            noResultsLabel.isHidden = true

        case .content(let items):
            loadingIndicator.stop()
            self.items = items
            noResultsLabel.isHidden = true
            showTable(for: viewModel.selectedType)

        case .empty(let message):
            loadingIndicator.stop()
            items = []
            noResultsLabel.text = message
            noResultsLabel.isHidden = false
            showTable(for: viewModel.selectedType)

        case .failure(let message):
            loadingIndicator.stop()
            items = []
            showTable(for: viewModel.selectedType)
            showErrorDialog(message: message)
        }
    }

    /// Shows the table that matches the selected type and reloads it.
    private func showTable(for type: ItemType) {
        let isAnime = type == .anime
        animeResultsTableView.isHidden = !isAnime
        mangaResultsTableView.isHidden = isAnime

        let visibleTable = isAnime ? animeResultsTableView : mangaResultsTableView
        visibleTable?.reloadData()
    }

    @IBAction private func itemTypeChanged(_ sender: UISegmentedControl) {
        viewModel.select(type: sender.selectedSegmentIndex == 0 ? .anime : .manga)
    }
}

extension SearchResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let preview = items[indexPath.row]

        // The two tables are distinguished by which one is visible, and the
        // visible one always matches `selectedType`.
        if tableView == mangaResultsTableView {
            let cell = tableView.dequeue(MangaPreviewTableViewCell.self, for: indexPath)
            cell.configure(with: preview, canEditList: viewModel.canEditList)
            cell.onMyListTapped = { [weak self] in
                self?.viewModel.openListSheet(for: preview)
            }
            return cell
        }

        let cell = tableView.dequeue(AnimePreviewTableViewCell.self, for: indexPath)
        cell.configure(with: preview, canEditList: viewModel.canEditList)
        cell.onMyListTapped = { [weak self] in
            self?.viewModel.openListSheet(for: preview)
        }
        return cell
    }
}

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isNearBottom else { return }
        viewModel.loadMoreIfNeeded()
    }
}

extension SearchResultsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.search(query: searchBar.text)
    }
}
