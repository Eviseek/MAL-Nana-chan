//
//  SearchResultsViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 20.03.2023.
//

//TODO: paging attribute is needed, so either change results to Response type or make another var?

import Foundation


class SearchResultsViewModel {
    
    var searchResultsVC: SearchResultsViewController
    var results = [Node]()
    
    private let defaults = UserDefaults.standard
    private var recentSearchesArr = [String]()
    
    init(_ vc: SearchResultsViewController) {
        self.searchResultsVC = vc
    }
    
    func viewDidLoad(query: String) {
        saveToDefaults(query: query)
        checkQuery(query)
    }
    
    private func checkQuery(_ query: String) {
        
        var modified: String = query
        
        if query.contains(" ") {
            modified = query.replacingOccurrences(of: " ", with: "%")
        }
        
        searchForQuery(query: modified)
    }
    
    private func searchForQuery(query: String) {
        
        //TODO: anime or manga
        
        var url = URLs.animeSearchURL.rawValue.replacingOccurrences(of: "{query}", with: query)
        print("my url is", url)
        
        
        DataDownloader.dataDownloader.fetchData(url, completion: { (results: Response?) in
            print(URLs.animeSearchURL.rawValue.appending(query))
            if let data = results?.data {
                self.results = data
            }
            self.searchResultsVC.tableView.reloadData()
        })
        
    }
    
    private func saveToDefaults(query: String) {
        
        recentSearchesArr = defaults.object(forKey: Identifiers.RecentSearches.rawValue) as? [String] ?? [String]()
        
        //check if there's not the same search already and add
        if !(recentSearchesArr.contains(query)) {
            recentSearchesArr.append(query)
        }
        
        defaults.set(recentSearchesArr, forKey: Identifiers.RecentSearches.rawValue)
    }
}
