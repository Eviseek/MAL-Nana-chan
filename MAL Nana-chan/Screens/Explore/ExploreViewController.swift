//
//  ExploreViewController.swift
//  MAL Nana-chan
//

import UIKit

/// The Explore tab: search, popular manga and community recommendations.
final class ExploreViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var exploreTableView: UITableView!
    @IBOutlet private weak var recentSearchesTableView: UITableView!
    @IBOutlet private weak var recentSearchesView: UIView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorMsglabel: UILabel!

    var viewModel: ExploreViewModel!
    var coordinator: MediaCoordinator?

    private let loadingIndicator = LoadingIndicator()
    private var rows: [ExploreRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableViews()
        searchBar.delegate = self
        bindViewModel()
        viewModel.onViewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setRecentSearchesVisible(false)
        viewModel.onViewDidAppear()
    }

    private func setUpTableViews() {
        exploreTableView.separatorStyle = .none
        exploreTableView.register(MangaSectionTableViewCell.self)
        exploreTableView.register(RecommendationTableViewCell.self)
        exploreTableView.dataSource = self
        exploreTableView.delegate = self

        recentSearchesTableView.register(RecentSearchesTableViewCell.self)
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onRecentSearchesChange = { [weak self] in
            self?.recentSearchesTableView.reloadData()
        }
        viewModel.onShowMessage = { [weak self] message in
            self?.showErrorDialog(message: message, title: Strings.Common.error)
        }
        viewModel.onOpenSearchResults = { [weak self] query in
            self?.coordinator?.showSearchResults(query: query)
        }
        viewModel.onOpenRecommendation = { [weak self] recommendation in
            self?.coordinator?.showRecommendation(recommendation)
        }
    }

    private func render(_ state: ViewState<[ExploreRow]>) {
        switch state {
        case .loading:
            loadingIndicator.start(in: view)

        case .content(let rows):
            loadingIndicator.stop()
            self.rows = rows
            errorView.isHidden = true
            exploreTableView.isHidden = false
            exploreTableView.reloadData()

        case .empty(let message), .failure(let message):
            loadingIndicator.stop()
            rows = []
            errorMsglabel.text = message
            errorView.isHidden = false
            exploreTableView.isHidden = true
        }
    }

    private func setRecentSearchesVisible(_ isVisible: Bool) {
        recentSearchesView.isHidden = !isVisible
        recentSearchesTableView.isHidden = !isVisible
    }

    @IBAction private func tryAgainButtonClicked(_ sender: UIButton) {
        viewModel.onRetryTapped()
    }
}

// MARK: - Table views

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView == recentSearchesTableView ? viewModel.recentSearchQueries.count : rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView == exploreTableView else {
            return recentSearchCell(in: tableView, at: indexPath)
        }

        switch rows[indexPath.row] {
        case .popularManga(let section):
            return popularMangaCell(in: tableView, at: indexPath, section: section)
        case .recommendation(let recommendation):
            return recommendationCell(in: tableView, at: indexPath, recommendation: recommendation)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recentSearchesTableView {
            viewModel.selectRecentSearch(at: indexPath.row)
        } else {
            viewModel.selectRow(at: indexPath.row)
        }
    }

    // Each cell gets its own small builder rather than one long `cellForRowAt`.

    private func popularMangaCell(
        in tableView: UITableView,
        at indexPath: IndexPath,
        section: MediaSection
    ) -> UITableViewCell {
        let cell = tableView.dequeue(MangaSectionTableViewCell.self, for: indexPath)
        // No "see all" here: this strip is a ranking snapshot, not a paginated
        // list, which is why the old code hid the button by hand every time.
        cell.configure(with: section, showsSeeAll: false)
        cell.onSelectItem = { [weak self] preview in
            self?.coordinator?.showDetail(for: preview)
        }
        return cell
    }

    private func recommendationCell(
        in tableView: UITableView,
        at indexPath: IndexPath,
        recommendation: Recommendation
    ) -> UITableViewCell {
        let cell = tableView.dequeue(RecommendationTableViewCell.self, for: indexPath)
        // `pair` is non-nil: the view model filtered out malformed entries.
        if let pair = recommendation.pair {
            cell.configure(with: pair)
        }
        return cell
    }

    private func recentSearchCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RecentSearchesTableViewCell.self, for: indexPath)
        cell.configure(query: viewModel.recentSearchQueries[indexPath.row])
        return cell
    }
}

// MARK: - Search bar

extension ExploreViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        setRecentSearchesVisible(false)
        viewModel.search(query: searchBar.text)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setRecentSearchesVisible(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        setRecentSearchesVisible(false)
    }
}
