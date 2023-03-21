//
//  SearchResultsViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit
import AlamofireImage

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var query: String?
    var resultsVM: SearchResultsViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let query = query else { return }
        
        resultsVM = SearchResultsViewModel(self)
        resultsVM?.viewDidLoad(query: query)
        
        let nib = UINib(nibName: Identifiers.ItemListTableViewCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Identifiers.ItemListTableViewCell.rawValue)
        tableView.dataSource = self
    }
    
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsVM?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ItemListTableViewCell.rawValue, for: indexPath) as? ItemListTableViewCell {
            let result = resultsVM?.results[indexPath.row].node
            cell.titleLabel.text = result?.title
            cell.ratingLabel.text = result?.mean?.description
            cell.typeLabel.text = result?.media_type?.rawValue
            cell.episodesLabel.text = result?.num_episodes?.description
            if let url = URL(string: result?.main_picture?.medium ?? "") {
                cell.itemImageView?.af.setImage(withURL: url)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    
    
}
