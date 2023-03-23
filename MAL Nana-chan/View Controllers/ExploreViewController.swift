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
    
    var exploreVM: ExploreViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreVM = ExploreViewModel(self)
        
        searchBar.delegate = self
        
        let nib = UINib(nibName: Identifiers.RSTableViewCell.rawValue, bundle: nil)
        recentSearchesTableView.register(nib, forCellReuseIdentifier: Identifiers.RSTableViewCell.rawValue)
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
    }
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exploreVM?.recentSearchesArr.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.RSTableViewCell.rawValue, for: indexPath) as? RecentSearchesTableViewCell {
            cell.rsTitleLabel.text = exploreVM?.recentSearchesArr[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exploreVM?.searchButtonClicked(query: exploreVM?.recentSearchesArr[indexPath.row])
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        exploreVM?.searchButtonClicked(query: searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        recentSearchesTableView.reloadData()
        recentSearchesView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        recentSearchesView.isHidden = true
    }
}
