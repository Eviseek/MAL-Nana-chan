//
//  ItemDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 06.02.2023.
//

import Foundation

class ItemDetailViewModel {
    
    private let indicator = ActivityIndicator()
    
    let dataDownloader = DataDownloader()
    
    var anime: Anime? = nil
    
    private var viewController: ItemDetailViewController
    var id: Int?
    
    init(viewController: ItemDetailViewController) { //TODO: type
        indicator.startAnimating(view: viewController.view, background: nil)
        self.viewController = viewController
        self.id = viewController.id
        if let _ = id {
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
                self.indicator.stopAnimating()
            } else {
                self.viewController.noData()
            }
        }
    }
    
    func addToListClicked() {
        if let picker = viewController.storyboard?.instantiateViewController(withIdentifier: "AnimelistDetailViewController") as? AnimelistDetailViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            picker.anime = anime
            viewController.present(picker, animated: true)
        }
    }
    
    
    
}
