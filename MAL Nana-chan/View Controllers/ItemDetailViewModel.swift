//
//  ItemDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 06.02.2023.
//

import Foundation

class ItemDetailViewModel {
    
    let dataDownloader = DataDownloader()
    
    var anime: Anime? = nil
    
    var viewController: ItemDetailViewController
    var id: Int?
    
    init(viewController: ItemDetailViewController) { //TODO: type
        self.viewController = viewController
        self.id = viewController.id
        if let id = id {
            getItemDetail()
        }
    }
    
    //TODO: type
    private func getItemDetail() {
        guard let id = id else { return }
        dataDownloader.fetchData(URLs.animeURLAll.rawValue.getURLWithId(id)) { (anime: Anime?) in
            self.anime = anime
            if anime != nil {
                self.viewController.updateView()
            } else {
                self.viewController.noData()
            }
        }
    }
    
    
    
}
