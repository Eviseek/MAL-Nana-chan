//
//  AnimeDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 06.02.2023.
//

import UIKit
import Alamofire

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
        indicator.startAnimating(view: viewController.view)
        self.id = viewController.id
        if let _ = id {
            fetchAnime()
        }
    }
    
    private func fetchAnime() {
        guard let id = id else { return }
        dataDownloader.fetchData(URLs.animeURLAll.rawValue.getURLWithId(id)) { (anime: Anime?, error: AFError?) in
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
        if let picker = viewController?.storyboard?.instantiateViewController(withIdentifier: "MyAnimeStatusViewController") as? MyAnimeStatusViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            picker.anime = anime
            viewController?.present(picker, animated: true)
        }
    }
    
    func selectedCollectionViewItem(at index: Int, cv: UICollectionView) {
        var type: ItemType = .anime
        var id: Int? = nil
        
        if cv == viewController?.relatedMangaCollectionView {
            type = .manga
            id = anime?.relatedManga?[index].node.id
        }
        
        if cv == viewController?.relatedAnimeCollectionView {
            type = .anime
            id = anime?.relatedAnime?[index].node.id
        }
        
        if cv == viewController?.recommendationsCollectionView {
            print("clicked rec")
            type = .anime
            id = anime?.recommendations?[index].node.id
        }
        
        switch type {
        case .anime:
            if let controller = viewController?.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailViewController") as? AnimeDetailViewController {
                controller.id = id
                viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        case .manga:
            if let controller = viewController?.storyboard?.instantiateViewController(withIdentifier: "MangaDetailViewController") as? MangaDetailViewController {
                controller.id = id
                viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    
    
}
