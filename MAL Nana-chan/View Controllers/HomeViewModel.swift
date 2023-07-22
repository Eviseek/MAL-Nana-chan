//
//  MainScreenViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit

class HomeViewModel {
    
    let indicator = ActivityIndicator()
    
    private var viewController: HomeViewController
    
    private let dataDownloader = DataDownloader()
    private let seasonManager = SeasonManager()
    
    var sections: [Section<Anime>]
    
    var promoId: String? = nil
    var hasPromo: Bool = false
    
    var contentSize: Int = 0
    
    private var urlManager = URLManager()
    
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
        self.sections = [Section<Anime>]()
        indicator.startAnimating(view: viewController.view, background: nil)
        viewDidLoad()
    }
    
    private func viewDidLoad() {
        getData {
            self.contentSize += self.sections.count
            self.viewController.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func getData(completion: @escaping () -> ()) {
        
        let group = DispatchGroup()
        let selectedSeason: Season = .winter
        let selectedYear = 2020
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForCustomSeason(season: selectedSeason, year: selectedYear)) { (response: Response<Anime>?) in
            if let response = response {
                self.sections.append(Section(name: "\(selectedSeason.stringValue()) \(selectedYear.description) anime", response: response))
            } else {
                self.viewController.showErrorDialog(message: "Something went wrong")
            }
            group.leave()
        }
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForThisSeason()) { (response: Response<Anime>?) in
            if let response = response {
                self.sections.append(Section(name: "This season anime", response: response))
            } else {
                self.viewController.showErrorDialog(message: "Something went wrong")
            }
            group.leave()
        }
        
        group.enter()
        dataDownloader.fetchData(urlManager.getURLForNextSeason()) { (response: Response<Anime>?) in
            if let response = response {
                self.sections.append(Section(name: "Upcoming season anime", response: response))
            } else {
                self.viewController.showErrorDialog(message: "Something went wrong")
            }
            group.leave()
        }
        
        
        group.enter()
        dataDownloader.fetchData(URLs.jikanPromoURL.rawValue, completion: { (response: Promo?) in
            if let data = response?.data {
                self.promoId = data[0].trailer?.youtube_id
                self.contentSize += 1
                self.hasPromo = true
            }
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    
}
