//
//  SearchResultsViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 20.03.2023.
//

//TODO: paging attribute is needed, so either change results to Response type or make another var?

import Alamofire
import UIKit

class SearchResultsViewModel {
    
    var viewController: SearchResultsViewController?
    var animeResults: Response<Anime>? = nil
    var mangaResults: Response<Manga>? = nil
    
    
    var pagingDone = false
    var loadingInProgress = false
    private var selectedType: ItemType = .anime
    private let defaults = UserDefaults.standard
    private var recentSearchesArr = [String]()
    
    init() {}
    
    func viewDidLoad(viewController: SearchResultsViewController) {
        self.viewController = viewController
        searchButtonClickedFor(.anime)
    }
    
    func searchButtonClickedFor(_ selectedType: ItemType) {
        
        pagingDone = false
        loadingInProgress = false
        
        self.selectedType = selectedType
        
        let query = viewController?.query
        
        if (query?.count ?? 0) > 2 {
            saveToDefaults(query: query!)
            searchForQuery(query!, type: self.selectedType)
        } else {
            showAlert()
        }
    }
    
    func loadMore() {
        
        if loadingInProgress == false && !pagingDone {
            
            loadingInProgress = true
            
            if selectedType == .anime {
                if let nextUrl = animeResults?.paging?.next {
                    DataDownloader.dataDownloader.fetchData(nextUrl, completion: { (results: Response<Anime>?, _: AFError?) in
                        self.animeResults?.paging = results?.paging
                        if let data = results?.data {
                            self.animeResults?.data.append(contentsOf: data)
                        }
                        self.loadingInProgress = false
                        self.viewController?.animeResultsTableView.reloadData()
                    })
                } else {
                    self.pagingDone = true
                }
            } else if selectedType == .manga {
                print("my next url is", mangaResults?.paging?.next)
                if let nextUrl = mangaResults?.paging?.next {
                    
                    DataDownloader.dataDownloader.fetchData(nextUrl, completion: { (results: Response<Manga>?, _: AFError?) in
                        self.mangaResults?.paging = results?.paging
                        print("my next paging" ,results?.paging?.next)
                        if let data = results?.data {
                            self.mangaResults?.data.append(contentsOf: data)
                        }
                        self.loadingInProgress = false
                        self.viewController?.mangaResultsTableView.reloadData()
                    })
                } else {
                    self.pagingDone = true
                }
            }
        }
    }
    
    func rowSelectedAt(_ index: Int) {
        switch selectedType {
        case .anime:
            if let controller = viewController?.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailViewController") as? AnimeDetailViewController {
                controller.id = animeResults?.data[index].node.id
                viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        case .manga:
            if let controller = viewController?.storyboard?.instantiateViewController(withIdentifier: "MangaDetailViewController") as? MangaDetailViewController {
                controller.id = mangaResults?.data[index].node.id
               // print("id of selected manga is \(mangaResults?.data[index].node.id)")
                viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    private func searchForQuery(_ query: String, type: ItemType) {
        
        //TODO: anime or manga
        
        if let url = encodeURL(query: query) {
            
            if type == .anime  {
                
               // print("ANIME")
                
                DataDownloader.dataDownloader.fetchData(url, completion: { (results: Response<Anime>?, _: AFError?) in
                    // print(URLs.animeSearchURL.rawValue.appending(query))
                    if let data = results {
                        self.animeResults = data
                        self.viewController?.updateTableView(.anime)
                    }
                    self.viewController?.animeResultsTableView.reloadData()
                })
                
            } else {
                
              //  print("MANGA")
                
                DataDownloader.dataDownloader.fetchData(url, completion: { (results: Response<Manga>?, error: AFError?) in
                    // print(URLs.animeSearchURL.rawValue.appending(query))
                    if let data = results {
                        self.mangaResults = data
                        self.viewController?.updateTableView(.manga)
                    } else {
                        self.viewController?.setUpErrorView(message: error?.localizedDescription ?? "")
                    }
                })
                
            }
        }
        
    }
    
    //TODO: not needed, delete it
    private func encodeURL(query: String) -> String? {
        if selectedType == .anime {
            let url = URLs.animeSearchURL.rawValue.replacingOccurrences(of: "{query}", with: query)
            return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        } else {
            let url = URLs.mangaSearchURL.rawValue.replacingOccurrences(of: "{query}", with: query)
            return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        }
    }
    
    private func saveToDefaults(query: String) {
        
       // print("saving to defaults")
        
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
        viewController?.present(alert, animated: true, completion: nil)
    }
}
