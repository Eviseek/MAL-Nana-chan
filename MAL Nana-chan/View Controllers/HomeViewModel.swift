//
//  MainScreenViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit

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
        indicator.startAnimating(view: viewController.view, background: viewController.view.backgroundColor)
        fetchData {
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchData(completion: @escaping () -> ()) {
        
        var errorOccured = false
        
        let group = DispatchGroup()
        let selectedSeason: Season = .winter
        let selectedYear = 2020
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForCustomSeason(season: selectedSeason, year: selectedYear)) { (response: Response<Anime>?) in
            if let response = response {
                self.sections.append(Section(name: "\(selectedSeason.stringValue()) \(selectedYear.description) anime", response: response))
            } else {
                errorOccured = true
            }
            group.leave()
        }
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForThisSeason()) { (response: Response<Anime>?) in
            if let response = response {
                self.sections.append(Section(name: "This season anime", response: response))
            } else {
                errorOccured = true
            }
            group.leave()
        }
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForNextSeason()) { (response: Response<Anime>?) in
            if let response = response {
                self.sections.append(Section(name: "Upcoming season anime", response: response))
            } else {
                errorOccured = true
            }
            group.leave()
        }
        
        
        group.enter()
        dataDownloader.fetchData(URLs.jikanPromoURL.rawValue, completion: { (response: Promo?) in
            if let data = response?.data {
                self.promoId = data[0].trailer?.youtube_id
                self.contentSize += 1
                self.hasPromo = true
            } else {
                errorOccured = true
            }
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            if errorOccured {
                self.viewController?.showErrorDialog(message: "Something went wrong.")
                self.viewController?.setUpErrorView()
            } else {
                print("all is cool, refresh")
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
