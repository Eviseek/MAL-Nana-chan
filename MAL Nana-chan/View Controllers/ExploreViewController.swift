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
    @IBOutlet weak var errorMsglabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    
    private var viewModel =  ExploreViewModel()
    
    private var recommendations = [RecommendationData]()
    private var section: Section<Manga>? = nil
    
    private var numberOfRec = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad(vc: self)
        searchBar.delegate = self
        
        tableViewSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      //  viewModel.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.viewWillAppear()
    }
    
    private func tableViewSetUp() {
        exploreTableView.separatorStyle = .none
        
        let nib = UINib(nibName: Identifiers.RSTableViewCell.rawValue, bundle: nil)
        recentSearchesTableView.register(nib, forCellReuseIdentifier: Identifiers.RSTableViewCell.rawValue)
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
        
        let exploreItemNib = UINib(nibName: "MangaSectionTableViewCell", bundle: nil)
        let exploreRecNib = UINib(nibName: "RecommendationTableViewCell", bundle: nil)
        exploreTableView.register(exploreItemNib, forCellReuseIdentifier: "MangaSectionTableViewCell")
        exploreTableView.register(exploreRecNib, forCellReuseIdentifier: "RecommendationTableViewCell")
        exploreTableView.dataSource = self
        exploreTableView.delegate = self
    }
    
    func setUpErrorView(message: String) {
        errorMsglabel.text = message
        exploreTableView.isHidden = true
        errorView.isHidden = false
    }
    
    func fillUpRecommendations(recommendation: Recommendation) {
        errorView.isHidden = true
        exploreTableView.isHidden = false
        self.recommendations = recommendation.data
        exploreTableView.reloadData()
    }
    
    func fillPopularManga(section: Section<Manga>) {
        errorView.isHidden = true
        exploreTableView.isHidden = false
        self.section = Section(name: section.name, response: section.response)
        exploreTableView.reloadData()
    }
    
    func refreshRecentSearches() {
        recentSearchesTableView.reloadData()
    }
    
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        viewModel.tryAgainButtonClicked()
    }
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == recentSearchesTableView {
            return viewModel.recentSearchesArr.count
        }
        
        if tableView == exploreTableView {
            print("this is explore")
            if recommendations.count >= numberOfRec {
                return (1 + numberOfRec) //1 is for the popular anime collection view and the rest for to show only a limited number of recommendations
            }
            return (1 + recommendations.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == exploreTableView {
            if indexPath.row == 0 {
                if let exploreCVCell = tableView.dequeueReusableCell(withIdentifier: "MangaSectionTableViewCell", for: indexPath) as? MangaSectionTableViewCell {
                    if let manga = section {
                        exploreCVCell.sectionNameLabel.text = manga.name
                        exploreCVCell.fillCollectionView(section: manga)
                        exploreCVCell.sectionSeeAllButton.isHidden = true
                        exploreCVCell.parentVC = self
                    } else {
                        print("no popular manga here")
                    }
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
        
        if tableView == recentSearchesTableView {
            if let recentSearchesCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.RSTableViewCell.rawValue, for: indexPath) as? RecentSearchesTableViewCell {
                recentSearchesCell.rsTitleLabel.text = viewModel.recentSearchesArr[indexPath.row]
                return recentSearchesCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recentSearchesTableView {
            viewModel.searchButtonClicked(query: viewModel.recentSearchesArr[indexPath.row])
        }
        if tableView == exploreTableView && indexPath.row > 0 { //recommendations start at 1st position
            print("clicked")
            viewModel.recommendationSelected(with: recommendations[indexPath.row])
        }
    }
    
}

extension ExploreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")
        viewModel.searchButtonClicked(query: searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        recentSearchesView.isHidden = false
        recentSearchesTableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        recentSearchesView.isHidden = true
        recentSearchesTableView.isHidden = true
    }
    
}
