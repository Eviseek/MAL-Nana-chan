//
//  AnimelistViewController.swift
//  MAL Nana-chan
//

import UIKit

/// The signed-in user's anime list.
final class AnimelistViewController: UIViewController {

    @IBOutlet private weak var notLoggedView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var collectionview: UICollectionView!
    @IBOutlet private weak var listTableView: UITableView!
    @IBOutlet private weak var emptyListLabel: UILabel!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorMsgLabel: UILabel!

    var viewModel: AnimelistViewModel!
    var coordinator: MediaCoordinator?

    private let loadingIndicator = LoadingIndicator()
    private var rows: [AnimelistRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        setUpFilterStrip()
        bindViewModel()
        viewModel.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }

    private func setUpTableView() {
        listTableView.register(AnimelistItemTableViewCell.self)
        listTableView.dataSource = self
        listTableView.delegate = self
    }

    private func setUpFilterStrip() {
        collectionview.register(AnimelistControlCollectionViewCell.self)
        collectionview.dataSource = self
        collectionview.delegate = self
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onFiltersChange = { [weak self] in
            self?.collectionview.reloadData()
        }
        viewModel.onOpenMedia = { [weak self] preview in
            self?.coordinator?.showDetail(for: preview)
        }
        viewModel.onOpenListSheet = { [weak self] target in
            self?.coordinator?.presentListSheet(for: target) { [weak self] in
                // The user changed something in the sheet, so the row's progress
                // and status are stale.
                self?.viewModel.reload()
            }
        }
        viewModel.onRequestSignIn = { [weak self] in
            self?.coordinator?.showLogin { [weak self] in
                self?.viewModel.reload()
            }
        }
    }

    /// One switch, one visible view. Every case sets all four containers, so no
    /// state can leave a stale view showing.
    private func render(_ state: AnimelistState) {
        switch state {
        case .signedOut:
            loadingIndicator.stop()
            rows = []
            show(list: false, signedOut: true, error: false, empty: false)

        case .loading:
            loadingIndicator.start(in: view)

        case .content(let rows):
            loadingIndicator.stop()
            self.rows = rows
            show(list: true, signedOut: false, error: false, empty: false)
            listTableView.reloadData()

        case .empty(let message):
            loadingIndicator.stop()
            rows = []
            emptyListLabel.text = message
            show(list: false, signedOut: false, error: false, empty: true)

        case .failure(let message):
            loadingIndicator.stop()
            rows = []
            errorMsgLabel.text = message
            show(list: false, signedOut: false, error: true, empty: false)
        }
    }

    private func show(list: Bool, signedOut: Bool, error: Bool, empty: Bool) {
        listTableView.isHidden = !list
        notLoggedView.isHidden = !signedOut
        errorView.isHidden = !error
        emptyListLabel.isHidden = !empty
    }

    @IBAction private func loginButtonClicked(_ sender: UIButton) {
        viewModel.onSignInTapped()
    }

    @IBAction private func tryAgainButtonClicked(_ sender: UIButton) {
        viewModel.onRetryTapped()
    }
}

// MARK: - Filter strip

extension AnimelistViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(AnimelistControlCollectionViewCell.self, for: indexPath)
        cell.configure(
            title: viewModel.filters[indexPath.item].title,
            isSelected: indexPath.item == viewModel.selectedFilterIndex
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectFilter(at: indexPath.item)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        collectionView.bounds.size
    }
}

// MARK: - List

extension AnimelistViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeue(AnimelistItemTableViewCell.self, for: indexPath)
        cell.configure(with: row)
        cell.onMyListTapped = { [weak self] in
            self?.viewModel.openListSheet(for: row)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isNearBottom else { return }
        viewModel.loadMoreIfNeeded()
    }
}
