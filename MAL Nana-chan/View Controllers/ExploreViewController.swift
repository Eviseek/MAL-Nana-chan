//
//  ExploreViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var recentSearchesTableView: UITableView!
    @IBOutlet weak var recentSearchesView: UIView!
    
    private var testingSearches = ["Naruto", "Nana", "FMA", "Shingeki no Kyojin S3"]
    
    var exploreVM: ExploreViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreVM = ExploreViewModel(self)
        
        searchBar.delegate = self
        
        let nib = UINib(nibName: Identifiers.RSTableViewCell.rawValue, bundle: nil)
        recentSearchesTableView.register(nib, forCellReuseIdentifier: Identifiers.RSTableViewCell.rawValue)
        recentSearchesTableView.dataSource = self
    }
}

extension ExploreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testingSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.RSTableViewCell.rawValue, for: indexPath) as? RecentSearchesTableViewCell {
            cell.rsTitleLabel.text = testingSearches[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
}


extension ExploreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController {
            vc.query = searchBar.text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        recentSearchesView.isHidden = false
    }
    
}
