//
//  MainScreenViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit
import Alamofire

class HomeViewModel {
    
    let indicator = ActivityIndicator()
    
    private var viewController: HomeViewController? = nil
    private let dataDownloader = DataDownloader()
    private let seasonManager = SeasonManager()
    private let networkManager = NetworkManager.shared
    
    var sections = [Section<Anime>]()
    
    var promoId: String? = nil
    var hasPromo: Bool = false
    
    var contentSize: Int = 0
    
    private var urlManager = URLManager()
    
    
    init() {}
    
    func viewDidLoad(vc: HomeViewController) {
        self.viewController = vc
        networkManager.reachabilityDelegate = self
        refreshData()
    }
    
    func fetchDataAgainClicked() {
        refreshData()
    }
    
    private func refreshData() {
        guard let viewController = viewController else { return }
        indicator.startAnimating(view: viewController.view)
        fetchData {
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchData(completion: @escaping () -> ()) {
        
        var errorOccured = false
        var errorMsg: String? = nil
        
        let group = DispatchGroup()
        let selectedSeason: Season = .winter
        let selectedYear = 2020
        
        var customYearAnime: Response<Anime>? = nil
        var upcomingAnime: Response<Anime>? = nil
        var currentAnime: Response<Anime>? = nil
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForCustomSeason(season: selectedSeason, year: selectedYear)) { (response: Response<Anime>?, error: AFError?) in
            if let response = response {
                customYearAnime = response
            } else {
                errorMsg = error?.localizedDescription
                errorOccured = true
            }
            group.leave()
        }
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForThisSeason()) { (response: Response<Anime>?, error: AFError?) in
            if let response = response {
                currentAnime = response
            } else {
                errorMsg = error?.localizedDescription
                errorOccured = true
            }
            group.leave()
        }
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForNextSeason()) { (response: Response<Anime>?, error: AFError?) in
            if let response = response {
                upcomingAnime = response
            } else {
                errorMsg = error?.localizedDescription
                errorOccured = true
            }
            group.leave()
        }
        
        
        group.enter()
        dataDownloader.fetchData(URLs.jikanPromoURL.rawValue, completion: { (response: Promo?, error: AFError?) in
            if let data = response?.data {
                self.promoId = data[0].trailer?.youtube_id
                self.contentSize += 1
                self.hasPromo = true
            } else {
                errorMsg = error?.localizedDescription
                errorOccured = true
            }
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            if errorOccured {
                self.viewController?.setUpErrorView(message: errorMsg ?? "")
            } else {
                if let customYearAnime = customYearAnime, let currentAnime = currentAnime, let upcomingAnime = upcomingAnime {
                    self.sections.append(Section(name: "\(selectedSeason.stringValue()) \(selectedYear.description) anime", response: customYearAnime))
                    self.sections.append(Section(name: "This season anime", response: currentAnime))
                    self.sections.append(Section(name: "Upcoming season anime", response: upcomingAnime))
                }
                self.contentSize += self.sections.count
                self.viewController?.reloadData()
            }
            completion()
        }
    }
    
}

extension HomeViewModel: NetworkManagerDelegate {
    func connectionRestored() {
        if sections.isEmpty {
            refreshData()
        } else {
            viewController?.showErrorDialog(message: "No need for refresh")
        }
        
    }
}
