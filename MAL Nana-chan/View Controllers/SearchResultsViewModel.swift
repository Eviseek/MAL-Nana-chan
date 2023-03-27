//
//  SearchResultsViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 20.03.2023.
//

//TODO: paging attribute is needed, so either change results to Response type or make another var?

import Foundation
import UIKit

class SearchResultsViewModel {
    
    var searchResultsVC: SearchResultsViewController
    var animeResults: Response<Anime>? = nil
    var mangaResults: Response<Manga>? = nil
    
    
    var pagingDone = false
    var loadingInProgress = false
    private var type: ItemTypes = .anime
    private let defaults = UserDefaults.standard
    private var recentSearchesArr = [String]()
    
    init(_ vc: SearchResultsViewController) {
        self.searchResultsVC = vc
    }
    
    func searchButtonClicked() {
        
        pagingDone = false
        loadingInProgress = false
        
        //checking if we're searching for anime or manga
        if searchResultsVC.segmentedControl.selectedSegmentIndex == 0 {
            type = .anime
        } else if searchResultsVC.segmentedControl.selectedSegmentIndex == 1 {
            type = .manga
        }
        
        let query = searchResultsVC.query
        
        if (query?.count ?? 0) > 2 {
            saveToDefaults(query: query!)
            searchForQuery(query!, type: type)
        } else {
            showAlert()
        }
    }
    
    func loadMore() {
        
        if loadingInProgress == false && !pagingDone {
            
            loadingInProgress = true
            
            if searchResultsVC.segmentedControl.selectedSegmentIndex == 0 {
                if let nextUrl = animeResults?.paging?.next {
                    DataDownloader.dataDownloader.fetchData(nextUrl, completion: { (results: Response<Anime>?) in
                        self.animeResults?.paging = results?.paging
                        if let data = results?.data {
                            self.animeResults?.data.append(contentsOf: data)
                        }
                        self.loadingInProgress = false
                        self.searchResultsVC.tableView.reloadData()
                    })
                } else {
                    self.pagingDone = true
                }
            } else if searchResultsVC.segmentedControl.selectedSegmentIndex == 1 {
                print("my next url is", mangaResults?.paging?.next)
                if let nextUrl = mangaResults?.paging?.next {
                    
                    DataDownloader.dataDownloader.fetchData(nextUrl, completion: { (results: Response<Manga>?) in
                        self.mangaResults?.paging = results?.paging
                        print("my next paging" ,results?.paging?.next)
                        if let data = results?.data {
                            self.mangaResults?.data.append(contentsOf: data)
                        }
                        self.loadingInProgress = false
                        self.searchResultsVC.tableView.reloadData()
                    })
                } else {
                    self.pagingDone = true
                }
            }
        }
    }
    
    private func searchForQuery(_ query: String, type: ItemTypes) {
        
        //TODO: anime or manga
        
        if let url = encodeURL(query: query) {
            
            if type == .anime  {
                
                print("ANIME")
                
                DataDownloader.dataDownloader.fetchData(url, completion: { (results: Response<Anime>?) in
                    // print(URLs.animeSearchURL.rawValue.appending(query))
                    if let data = results {
                        self.animeResults = data
                    }
                    self.searchResultsVC.tableView.reloadData()
                })
                
            } else {
                
                print("MANGA")
                
                DataDownloader.dataDownloader.fetchData(url, completion: { (results: Response<Manga>?) in
                    // print(URLs.animeSearchURL.rawValue.appending(query))
                    if let data = results {
                        self.mangaResults = data
                    }
                    self.searchResultsVC.tableView.reloadData()
                })
                
            }
        }
        
    }
    
    private func encodeURL(query: String) -> String? {
        if type == .anime {
            let url = URLs.animeSearchURL.rawValue.replacingOccurrences(of: "{query}", with: query)
            return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        } else {
            let url = URLs.mangaSearchURL.rawValue.replacingOccurrences(of: "{query}", with: query)
            return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        }
    }
    
    private func saveToDefaults(query: String) {
        
        print("saving to defaults")
        
        recentSearchesArr = defaults.object(forKey: Identifiers.RecentSearches.rawValue) as? [String] ?? [String]()
        
        //check if there's not the same search already and add
        if !(recentSearchesArr.contains(query)) {
            recentSearchesArr.append(query)
        }
        
        defaults.set(recentSearchesArr, forKey: Identifiers.RecentSearches.rawValue)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Query must have at least 3 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        searchResultsVC.present(alert, animated: true, completion: nil)
    }
}
