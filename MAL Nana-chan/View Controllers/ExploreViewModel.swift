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
    
    private func getRecentSearchesFromDefaults() {
        recentSearchesArr = defaults.object(forKey: Identifiers.RecentSearches.rawValue) as? [String] ?? [String]()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Query must have at least 3 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        exploreVC.present(alert, animated: true, completion: nil)
    }
    
}
