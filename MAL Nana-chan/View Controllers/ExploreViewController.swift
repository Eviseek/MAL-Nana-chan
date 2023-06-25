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
    
    private var exploreVM: ExploreViewModel?
    
    private var recommendations = [RecommendationData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreVM = ExploreViewModel(self)
        searchBar.delegate = self
        
        tableViewSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        exploreVM?.viewWillAppear()
    }
    
    private func tableViewSetUp() {
        let nib = UINib(nibName: Identifiers.RSTableViewCell.rawValue, bundle: nil)
        recentSearchesTableView.register(nib, forCellReuseIdentifier: Identifiers.RSTableViewCell.rawValue)
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
        
        let exploreItemNib = UINib(nibName: "ItemSectionTableViewCell", bundle: nil)
        let exploreRecNib = UINib(nibName: "RecommendationTableViewCell", bundle: nil)
        exploreTableView.register(exploreItemNib, forCellReuseIdentifier: "ItemSectionTableViewCell")
        exploreTableView.register(exploreRecNib, forCellReuseIdentifier: "RecommendationTableViewCell")
        exploreTableView.dataSource = self
     //   exploreTableView.delegate = self
    }
    
    func fillUpRecommendations(recommendation: Recommendation) {
        self.recommendations = recommendation.data
        exploreTableView.reloadData()
    }
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentSearchesTableView {
            return exploreVM?.recentSearchesArr.count ?? 0
        }
        if tableView == exploreTableView {
            print("this is explore")
            return recommendations.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == exploreTableView {
            if indexPath.row == 0 {
                if let exploreItemCell = tableView.dequeueReusableCell(withIdentifier: "ItemSectionTableViewCell", for: indexPath) as? ItemSectionTableViewCell {
                    //TODO: what section?
                    return exploreItemCell
                }
            }
            
            if let exploreCell = tableView.dequeueReusableCell(withIdentifier: "RecommendationTableViewCell", for: indexPath) as? RecommendationTableViewCell {
                //TODO: download and get data from jikan
                return exploreCell
            }
        }
        
        if tableView == recentSearchesView {
            if let recentSearchesCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.RSTableViewCell.rawValue, for: indexPath) as? RecentSearchesTableViewCell {
                recentSearchesCell.rsTitleLabel.text = exploreVM?.recentSearchesArr[indexPath.row]
                return recentSearchesCell
            }
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
        recentSearchesView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        recentSearchesView.isHidden = true
    }
}
