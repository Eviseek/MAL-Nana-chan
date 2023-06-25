//
//  SeeAllViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.06.2023.
//

import Foundation

class seeAllViewModel {
    
    //for loading animation
    private let indicator = ActivityIndicator()
    
    private var viewController: SeeAllViewController
    private var sectionContent: Section
    
    private var dataDownloader: DataDownloader
    private var fields = ["mean", "media_type", "status", "num_episodes", "source", "start_season"]
    
    private var animeArr = [Anime]()
    
    
    init(viewController: SeeAllViewController, content: Section) {
        self.viewController = viewController
        self.sectionContent = content
        indicator.startAnimating(view: viewController.view)
        dataDownloader = DataDownloader()
        fetchData()
    }
    
    private func fetchData() {
        DataDownloader.dataDownloader.fetchData(appendFields(fields: fields, url: ""), completion: { (result: Response<Anime>?) in
            if let data = result?.data {
                //creating a new array so I can pass all anime to view controller
                for single in data {
                    self.animeArr.append(single.node)
                }
                self.viewController.fillTableView(items: self.animeArr) { //stop the loading animation once data passed
                    self.indicator.stopAnimating()
                }
            } else {
                //TODO: show error dialog and close screen on ok click
                return
            }
        })
    }
    
    private func getCleanUrl(url: String) -> String {
        var changedUrl = url
        if let questionMarkRange = url.range(of: "=") { //fields=
            changedUrl.removeSubrange(questionMarkRange.lowerBound..<url.endIndex)
            print("my new url \(changedUrl)")
        }
        
        return changedUrl
    }
    
    private func appendFields(fields: [String], url: String) -> String {
        
        var changedUrl = getCleanUrl(url: url)
        changedUrl += "="
        
        for i in 0...fields.count-1 {
            changedUrl += fields[i]
            if i != fields.count-1 {
                changedUrl += ","
            }
        }
        print("new url \(changedUrl)")
        
        return changedUrl
    }
    
}
