//
//  ExploreViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit

class ExploreViewModel {
    
    private var vc: ExploreViewController? = nil
    private let defaults = UserDefaults.standard
    private let networkManager = NetworkManager.shared
    
    var popularSection: Section<Anime>? = nil
    
    var recentSearchesArr: [String] = [String]()
    
    init() {}
    
    func viewDidLoad(vc: ExploreViewController) {
        self.vc = vc
        self.checkRecentSearchesTime()
        self.recentSearchesArr = getRecentSearches()
        networkManager.reachabilityDelegate = self
        downloadData()
    }
    
    private func downloadData() {
        guard let vc = vc else { return }
        ActivityIndicator.indicator.startAnimating(view: vc.view, background: nil)
        fetchData {
            ActivityIndicator.indicator.stopAnimating()
        }
    }
    
    private func fetchData(completion: @escaping () -> Void) {
        
        var errorOccured = false
        
        let group = DispatchGroup()
        
        group.enter()
        DataDownloader.dataDownloader.fetchData(URLs.jikanRecommendationsAnimeURL.rawValue) { (result: Recommendation?) in
            print("result is?")
            if let result = result {
                print(result)
                self.vc?.fillUpRecommendations(recommendation: result)
            } else {
                errorOccured = true
            }
            group.leave()
        }
        
        group.enter()
        DataDownloader.dataDownloader.fetchData(URLs.animePopularURL.rawValue) { (result: Response<Anime>?) in
            if let result = result {
                self.popularSection = Section(name: "Popular anime", response: result)
                self.vc?.fillPopularAnime(section: self.popularSection!)
            } else {
                print("NOT FETCHED popular anime")
                errorOccured = true
            }
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            if errorOccured {
                self.vc?.showErrorDialog(message: "Something went wrong.")
                self.vc?.setUpErrorView()
            }
            completion()
        }
    }
    
    func recommendationSelected(with recommendation: RecommendationData) {
        if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "RecommendationDetailViewController") as? RecommendationDetailViewController {
            controller.recommendation = recommendation
            vc?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func searchButtonClicked(query: String?) {
        if (query?.count ?? 0) > 2 {
            saveToRecentSearches(query: query!)
            if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController {
                controller.query = query
                vc?.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            showAlert()
        }
    }
    
    func viewWillAppear() {
        vc?.recentSearchesView.isHidden = true
        recentSearchesArr = getRecentSearches()
        print("recentSearchesArr is \(recentSearchesArr)")
        vc?.refreshRecentSearches()
    }
    
    private func saveToRecentSearches(query: String) {
        
        var alreadyThere = false
        
        for search in recentSearchesArr {
            if search == query {
                alreadyThere = true
            }
        }
        
        if !alreadyThere {
            recentSearchesArr.append(query)
            defaults.set(recentSearchesArr, forKey: Identifiers.RecentSearches.rawValue)
            //saving date to delete it if longer than week
            defaults.set(Date(), forKey: "RecentSearchesLastSave")
            vc?.refreshRecentSearches()
        }
    }
    
    private func getRecentSearches() -> [String] {
        return defaults.object(forKey: Identifiers.RecentSearches.rawValue) as? [String] ?? [String]()
    }
    
    private func checkRecentSearchesTime() {
        let previous = defaults.object(forKey: "RecentSearchesLastSave") as? Date
        if let previous = previous {
            print("previous is \(previous)")
            if let timeBetween = Calendar.current.dateComponents([.day], from: previous, to: Date()).day {
                print("time between is \(timeBetween)")
                if timeBetween >= 1 {
                    print("bigger than one")
                    //TODO: delete array
                }
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Query must have at least 3 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        vc?.present(alert, animated: true, completion: nil)
    }
    
}

extension ExploreViewModel: NetworkManagerDelegate {
    func connectionRestored() {
        if popularSection == nil {
            downloadData()
        }
    }
}
