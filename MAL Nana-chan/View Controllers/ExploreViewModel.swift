//
//  ExploreViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit

class ExploreViewModel {
    
    private var vc: ExploreViewController
    private let defaults = UserDefaults.standard
    
    var recentSearchesArr = [String]()
    
    init(_ vc: ExploreViewController) {
        print("CREATED")
        self.vc = vc
        ActivityIndicator.indicator.startAnimating(view: vc.view, background: nil)
        getRecentSearchesFromDefaults()
        fetchData()
    }
    
    private func fetchData() {
        DataDownloader.dataDownloader.fetchData(URLs.jikanRecommendationsAnimeURL.rawValue) { (result: Recommendation?) in
            print("result is?")
            if let result = result {
                print(result)
                self.vc.fillUpRecommendations(recommendation: result)
            } else {
                print("result is not")
            }
            ActivityIndicator.indicator.stopAnimating()
        }
        
        
        DataDownloader.dataDownloader.fetchData(URLs.animePopularURL.rawValue) { (result: Response<Anime>?) in
            if let data = result?.data {
                var section = Section()
                for anime in data {
                    let item = Item(id: anime.node.id, title: anime.node.title, image: anime.node.mainPicture?.medium, score: anime.node.score)
                    section.items.append(item)
                    print("appended item \(item)")
                    print("appending items")
                }
                print("passing items")
                print("items in section are \(section.items)")
                self.vc.fillPopularAnime(anime: section.items)
            } else {
                print("NOT FETCHED popular anime")
                //TODO: result not fetched
            }
        }
        
    }
    
    func recommendationSelected(with recommendation: RecommendationData) {
        if let controller = vc.storyboard?.instantiateViewController(withIdentifier: "RecommendationDetailViewController") as? RecommendationDetailViewController {
            controller.recommendation = recommendation
            vc.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func searchButtonClicked(query: String?) {
        
        //TODO: add to local storage
        
        if (query?.count ?? 0) > 2 {
            if let vc = vc.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController {
                vc.query = query
                vc.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            showAlert()
        }
    }
    
    func viewWillAppear() {
        getRecentSearchesFromDefaults()
        vc.recentSearchesTableView.reloadData()
    }
    
    private func getRecentSearchesFromDefaults() {
        recentSearchesArr = defaults.object(forKey: Identifiers.RecentSearches.rawValue) as? [String] ?? [String]()
        print("got recent searches", recentSearchesArr)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Query must have at least 3 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}
