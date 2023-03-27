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
        
        resultsVM = SearchResultsViewModel(self)
        resultsVM?.searchButtonClicked()
        
        searchBar.text = query
        searchBar.delegate = self
        
        let nib = UINib(nibName: Identifiers.ItemListTableViewCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Identifiers.ItemListTableViewCell.rawValue)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func itemTypeChanged(_ sender: UISegmentedControl) {
        //TODO: manga
        resultsVM?.searchButtonClicked()
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return resultsVM?.animeResults?.data.count ?? 0
        } else {
            return resultsVM?.mangaResults?.data.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ItemListTableViewCell.rawValue, for: indexPath) as? ItemListTableViewCell {
            if segmentedControl.selectedSegmentIndex == 0 {
                let anime = resultsVM?.animeResults?.data[indexPath.row].node
                var seasonText = ""
                
                cell.titleLabel.text = anime?.title
                if let season = anime?.start_season?.season {
                    seasonText = season.stringValue()
                    seasonText += " "
                }
                if let year = anime?.start_season?.year {
                    seasonText += year.description
                }
                cell.seasonLabel.text = seasonText
                if let score = anime?.mean {
                    cell.ratingLabel.text = score.description
                }
                cell.typeLabel.text = anime?.media_type?.getType()
                cell.updateEpisodesLabel(type: .anime, number: anime?.num_episodes ?? 0)
                if (anime?.num_episodes ?? 0) > 0 {
                    cell.episodesNumberLabel.text = anime?.num_episodes?.description
                }
                
                if let url = URL(string: anime?.main_picture?.medium ?? "") {
                    cell.itemImageView?.af.setImage(withURL: url)
                }
                
                return cell
                
            } else {
                let manga = resultsVM?.mangaResults?.data[indexPath.row].node
                cell.titleLabel.text = manga?.title
                cell.seasonLabel.text = manga?.start_date?.extractSeason()
                if let score = manga?.mean {
                    cell.ratingLabel.text = score.description
                }
                cell.typeLabel.text = manga?.media_type?.getType()
                cell.updateEpisodesLabel(type: .manga, number: manga?.num_chapters ?? 0)
                if (manga?.num_chapters ?? 0) > 0 {
                    cell.episodesNumberLabel.text = manga?.num_chapters?.description
                }
                
                if let url = URL(string: manga?.main_picture?.medium ?? "") {
                    cell.itemImageView?.af.setImage(withURL: url)
                }
                
                return cell
                
            }
        }
        return UITableViewCell()
    }
}

extension SearchResultsViewController: UITableViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.height) {
            if !(resultsVM?.pagingDone ?? true) && !(resultsVM?.loadingInProgress ?? true) {
                resultsVM?.loadMore()
            }
        }
    }
}
    
extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query = searchBar.text
        resultsVM?.searchButtonClicked()
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.tableView.contentOffset.y = 0
        })
    }
    
}
