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
    
    var sections = [Section]()
    
    var promoId: String? = nil
    var hasPromo: Bool = false
    
    var contentSize: Int = 0
    
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
        indicator.startAnimating(view: viewController.view)
        viewDidLoad()
    }
    
    private func viewDidLoad() {
        getData {
            self.contentSize += self.sections.count
            self.viewController.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    //TODO: optimize the url strings getting
    private func getData(completion: @escaping () -> ()) {
        
        let group = DispatchGroup()
        group.enter()
        dataDownloader.fetchData("https://api.myanimelist.net/v2/anime/season/2020/spring?fields=mean") { (response: Response<Anime>?) in
            if let data = response?.data {
                self.createSection(sectionName: "Spring 2020 anime", data: data, url: "https://api.myanimelist.net/v2/anime/season/2020/spring?fields=mean")
              //  print(data)
            }
            group.leave()
        }
        
        group.enter()
        let season = SeasonManager().getThisSeason().stringValue()
        var year = Calendar.current.component(.year, from: Date()) //Today's year
        dataDownloader.fetchData("https://api.myanimelist.net/v2/anime/season/\(year)/\(season.lowercased())?fields=mean") { (response: Response<Anime>?) in
            if let data = response?.data {
                self.createSection(sectionName: "This season (\(season) \(year)) anime", data: data, url: "https://api.myanimelist.net/v2/anime/season/\(year)/\(season.lowercased())?fields=mean")
               // print(data)
            }
            group.leave()
        }
        
        group.enter()
        let nextSeasonTupple = seasonManager.getUpcomingSeason()
        let nextSeason = nextSeasonTupple.0.stringValue()
        print("I AM NEXT SEASON" ,nextSeason)
        var nextSeasonYear = year
        if nextSeasonTupple.1 == true {
            nextSeasonYear += 1
        }
        dataDownloader.fetchData("https://api.myanimelist.net/v2/anime/season/\(nextSeasonYear)/\(nextSeason.lowercased())?fields=mean") { (response: Response<Anime>?) in
            if let data = response?.data {
                self.createSection(sectionName: "Upcoming (\(nextSeason) \(nextSeasonYear)) anime", data: data, url: "https://api.myanimelist.net/v2/anime/season/\(nextSeasonYear)/\(nextSeason.lowercased())?fields=mean")
               // print(data)
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
    
    private func createSection(sectionName: String?, data: [Node<Anime>], url: String?) {
        
        var items = [Item]()
        
        for data in data {
            items.append(Item(id: data.node.id, title: data.node.title, image: data.node.mainPicture?.medium ?? nil, score: data.node.score ?? nil))
        }
        
        var section = Section(items: items, url: url)
        
        if let sectionName = sectionName {
            section.name = sectionName
        }
        
        sections.append(section)
    }
    
    
    
}
