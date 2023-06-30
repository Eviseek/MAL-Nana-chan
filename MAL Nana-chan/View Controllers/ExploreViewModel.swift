//
//  ExploreViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit

class ExploreViewModel {
    
    private var exploreVC: ExploreViewController
    private let defaults = UserDefaults.standard
    
    var recentSearchesArr = [String]()
    
    init(_ exploreVC: ExploreViewController) {
        print("CREATED")
        self.exploreVC = exploreVC
        getRecentSearchesFromDefaults()
        fetchData()
    }
    
    private func fetchData() {
        DataDownloader.dataDownloader.fetchData(URLs.jikanRecommendationsAnimeURL.rawValue) { (result: Recommendation?) in
            print("result is?")
            if let result = result {
                print(result)
                self.exploreVC.fillUpRecommendations(recommendation: result)
            } else {
                print("result is not")
            }
        }
        
        
        DataDownloader.dataDownloader.fetchData(URLs.animePopularURL.rawValue) { (result: Response<Anime>?) in
            if let data = result?.data {
                var section = Section()
                for anime in data {
                    let item = Item(id: anime.node.id, title: anime.node.title, image: anime.node.main_picture?.medium, score: anime.node.mean)
                    section.items.append(item)
                    print("appended item \(item)")
                    print("appending items")
                }
                print("passing items")
                print("items in section are \(section.items)")
                self.exploreVC.fillPopularAnime(anime: section.items)
            } else {
                print("NOT FETCHED popular anime")
                //TODO: result not fetched
            }
        }
        
    }
    
    func recommendationSelected(with recommendation: RecommendationData) {
        if let controller = exploreVC.storyboard?.instantiateViewController(withIdentifier: "RecommendationDetailViewController") as? RecommendationDetailViewController {
            controller.recommendation = recommendation
            exploreVC.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func searchButtonClicked(query: String?) {
        
        //TODO: add to local storage
        
        if (query?.count ?? 0) > 2 {
            if let vc = exploreVC.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController {
                vc.query = query
                exploreVC.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            showAlert()
        }
    }
    
    func viewWillAppear() {
        getRecentSearchesFromDefaults()
        exploreVC.recentSearchesTableView.reloadData()
    }
    
    private func getRecentSearchesFromDefaults() {
        recentSearchesArr = defaults.object(forKey: Identifiers.RecentSearches.rawValue) as? [String] ?? [String]()
        print("got recent searches", recentSearchesArr)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Query must have at least 3 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        exploreVC.present(alert, animated: true, completion: nil)
    }
    
}
