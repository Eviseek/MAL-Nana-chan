//
//  AnimeDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 06.02.2023.
//

import Foundation

class AnimeDetailViewModel {
    
    private let indicator = ActivityIndicator()
    
    let dataDownloader = DataDownloader()
    
    var anime: Anime? = nil
    var manga: Manga? = nil
    
    private var viewController: AnimeDetailViewController? = nil
    var id: Int?
    
    init() {}
    
    func viewDidLoad(viewController: AnimeDetailViewController) {
        self.viewController = viewController
        indicator.startAnimating(view: viewController.view, background: nil)
        self.id = viewController.id
        if let _ = id {
            fetchAnime()
        }
    }
    
    private func fetchAnime() {
        guard let id = id else { return }
        dataDownloader.fetchData(URLs.animeURLAll.rawValue.getURLWithId(id)) { (anime: Anime?) in
            self.anime = anime
            if anime != nil {
                self.viewController?.updateView()
                self.indicator.stopAnimating()
            } else {
                self.viewController?.noData()
            }
        }
    }
    
    func addToListClicked() {
        if let picker = viewController?.storyboard?.instantiateViewController(withIdentifier: "MyListViewController") as? MyListViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            picker.anime = anime
            viewController?.present(picker, animated: true)
        }
    }
    
    
    
}
