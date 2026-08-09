//
//  ThemesDetailViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Opening and ending themes for one anime. Tapping one searches YouTube.
final class ThemesDetailViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorMsgLabel: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    var viewModel: ThemesDetailViewModel!

    private var titles: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ThemeTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self

        bindViewModel()
        viewModel.onViewDidLoad()
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onOpenURL = { url in
            UIApplication.shared.open(url)
        }
    }

    private func render(_ state: ViewState<[String]>) {
        switch state {
        case .loading:
            errorView.isHidden = true

        case .content(let titles):
            self.titles = titles
            errorView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()

        case .empty(let message), .failure(let message):
            titles = []
            errorMsgLabel.text = message
            errorView.isHidden = false
            tableView.isHidden = true
        }
    }

    @IBAction private func tryAgainButtonClicked(_ sender: UIButton) {
        viewModel.onRetryTapped()
    }

    @IBAction private func segmentedControlChanged(_ sender: UISegmentedControl) {
        // Which half is showing is the view model's state now, so the table isn't
        // reloaded from two places with two different sources of truth.
        viewModel.select(kind: sender.selectedSegmentIndex == 0 ? .openings : .endings)
    }
}

extension ThemesDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ThemeTableViewCell.self, for: indexPath)
        cell.configure(title: titles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectTheme(at: indexPath.row)
    }
}
