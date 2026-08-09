//
//  SeeAllViewController.swift
//  MAL Nana-chan
//

import UIKit

/// The full list behind a section's "see all" button.
final class SeeAllViewController: UIViewController {

    private let viewModel: SeeAllViewModel
    var coordinator: MediaCoordinator?

    private let tableView = UITableView()
    private var items: [MediaPreview] = []

    init(viewModel: SeeAllViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    /// Never used — this screen is not created from a nib or storyboard.
    required init?(coder: NSCoder) {
        fatalError("SeeAllViewController must be created with init(viewModel:).")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        setUpTableView()
        bindViewModel()
    }

    private func setUpTableView() {
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        // Only the cell this section actually needs is registered.
        switch viewModel.kind {
        case .anime: tableView.register(AnimePreviewTableViewCell.self)
        case .manga: tableView.register(MangaPreviewTableViewCell.self)
        }
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onOpenMedia = { [weak self] preview in
            self?.coordinator?.showDetail(for: preview)
        }
        viewModel.onOpenListSheet = { [weak self] target in
            self?.coordinator?.presentListSheet(for: target)
        }
        render(viewModel.state)
    }

    private func render(_ state: ViewState<[MediaPreview]>) {
        switch state {
        case .loading:
            break

        case .content(let items):
            self.items = items
            tableView.reloadData()

        case .empty, .failure:
            items = []
            tableView.reloadData()
        }
    }
}

extension SeeAllViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let preview = items[indexPath.row]

        switch viewModel.kind {
        case .anime:
            let cell = tableView.dequeue(AnimePreviewTableViewCell.self, for: indexPath)
            cell.configure(with: preview, canEditList: viewModel.canEditList)
            cell.onMyListTapped = { [weak self] in
                self?.viewModel.openListSheet(for: preview)
            }
            return cell

        case .manga:
            let cell = tableView.dequeue(MangaPreviewTableViewCell.self, for: indexPath)
            cell.configure(with: preview, canEditList: viewModel.canEditList)
            cell.onMyListTapped = { [weak self] in
                self?.viewModel.openListSheet(for: preview)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isNearBottom else { return }
        viewModel.loadMoreIfNeeded()
    }
}
