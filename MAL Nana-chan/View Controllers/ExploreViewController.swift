//
//  ExploreViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit
import AlamofireImage

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var recentSearchesTableView: UITableView!
    @IBOutlet weak var recentSearchesView: UIView!
    
    private var exploreVM: ExploreViewModel?
    
    private var recommendations = [RecommendationData]()
    private var popularAnime = Section(name: "10 popular anime")
    
    private var numberOfRec = 10
    
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
        exploreTableView.separatorStyle = .none
        
        let nib = UINib(nibName: Identifiers.RSTableViewCell.rawValue, bundle: nil)
        recentSearchesTableView.register(nib, forCellReuseIdentifier: Identifiers.RSTableViewCell.rawValue)
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
        
        let exploreItemNib = UINib(nibName: "ItemSectionTableViewCell", bundle: nil)
        let exploreRecNib = UINib(nibName: "RecommendationTableViewCell", bundle: nil)
        exploreTableView.register(exploreItemNib, forCellReuseIdentifier: "ItemSectionTableViewCell")
        exploreTableView.register(exploreRecNib, forCellReuseIdentifier: "RecommendationTableViewCell")
        exploreTableView.dataSource = self
        exploreTableView.delegate = self
    }
    
    func fillUpRecommendations(recommendation: Recommendation) {
        self.recommendations = recommendation.data
        exploreTableView.reloadData()
    }
    
    func fillPopularAnime(anime: [Item]) {
        self.popularAnime.items = anime
        print("items are \(anime)")
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
            if recommendations.count >= numberOfRec {
                return (1 + numberOfRec) //1 is for the popular anime collection view and the resst for to show only a limited number of recommendations
            }
            return (1 + recommendations.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == exploreTableView {
            if indexPath.row == 0 {
                if let exploreCVCell = tableView.dequeueReusableCell(withIdentifier: "ItemSectionTableViewCell", for: indexPath) as? ItemSectionTableViewCell {
                    exploreCVCell.itemSectionNameLabel.text = popularAnime.name
                    exploreCVCell.fillCollectionView(section: popularAnime)
                    exploreCVCell.seeAllButton.isHidden = true
                    exploreCVCell.parentVC = self
                    return exploreCVCell
                }
            }
            
            if let exploreCell = tableView.dequeueReusableCell(withIdentifier: "RecommendationTableViewCell", for: indexPath) as? RecommendationTableViewCell {
                print("this is index \(indexPath.row)")
                //TODO: download and get data from jikan
                let leftRec = recommendations[indexPath.row].entry[0]
                let rightRec = recommendations[indexPath.row].entry[1]
                if let url = URL(string: leftRec.images.jpg.imageUrl) {
                    exploreCell.leftRecImageView.af.setImage(withURL: url)
                }
                exploreCell.leftRecTitleLabel.text = leftRec.title
                if let url = URL(string: rightRec.images.jpg.imageUrl) {
                    exploreCell.rightRecImageView.af.setImage(withURL: url)
                }
                exploreCell.rightRecTitleLabel.text = rightRec.title
                exploreCell.selectionStyle = .none
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
        if tableView == recentSearchesTableView {
            exploreVM?.searchButtonClicked(query: exploreVM?.recentSearchesArr[indexPath.row])
        }
        if tableView == exploreTableView && indexPath.row > 0 { //recommendations start at 1st position
            print("clicked")
            exploreVM?.recommendationSelected(with: recommendations[indexPath.row])
        }
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
