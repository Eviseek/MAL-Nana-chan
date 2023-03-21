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
    
    init(_ vc: SearchResultsViewController) {
        self.searchResultsVC = vc
    }
    
    func viewDidLoad(query: String) {
        searchForQuery(query: query)
    }
    
    private func searchForQuery(query: String) {
        
        //TODO: anime or manga
        
        print("searching")
        
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
    
    
}
