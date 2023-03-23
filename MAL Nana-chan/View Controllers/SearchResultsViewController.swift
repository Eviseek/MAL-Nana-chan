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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var query: String?
    var resultsVM: SearchResultsViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let query = query else { return }
        
        resultsVM = SearchResultsViewModel(self)
        resultsVM?.viewDidLoad(query: query)
        
        searchBar.text = query
        searchBar.delegate = self
        
        let nib = UINib(nibName: Identifiers.ItemListTableViewCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Identifiers.ItemListTableViewCell.rawValue)
        tableView.dataSource = self
    }
    
    @IBAction func itemTypeChanged(_ sender: UISegmentedControl) {
        //TODO: manga
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsVM?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ItemListTableViewCell.rawValue, for: indexPath) as? ItemListTableViewCell {
            let result = resultsVM?.results[indexPath.row].node
            var seasonText = ""
            cell.titleLabel.text = result?.title
            if let season = result?.start_season?.season {
                seasonText = season.stringValue()
                seasonText += " "
            }
            if let year = result?.start_season?.year {
                seasonText += year.description
            }
            cell.seasonLabel.text = seasonText
            if let score = result?.mean {
                cell.ratingLabel.text = score.description
            }
            cell.typeLabel.text = result?.media_type?.getType()
            cell.updateEpisodesLabel(type: .anime, number: result?.num_episodes ?? 0)
            if (result?.num_episodes ?? 0) > 0 {
                cell.episodesNumberLabel.text = result?.num_episodes?.description
            }
            
            if let url = URL(string: result?.main_picture?.medium ?? "") {
                cell.itemImageView?.af.setImage(withURL: url)
            }
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SearchResultsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //TODO: search again
    }
    
}
