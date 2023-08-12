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
    private let dataDownloader = DataDownloader()
    private let networkManager = NetworkManager()
    
    private var vc: AnimeDetailViewController? = nil
    
    var id: Int?
    var anime: Anime? = nil
    
    init() {}
    
    func viewDidLoad(viewController: AnimeDetailViewController, id: Int) {
        self.vc = viewController
        self.id = id
        
        if !(TokenHandler.isUserLoggedIn) {
            vc?.myListButton.removeFromSuperview()
        }
        
        fetchAnimeForId(id)
    }
    
    private func fetchAnimeForId(_ id: Int) {
        guard let vc = vc else { return }
        indicator.startAnimating(view: vc.view)
        dataDownloader.fetchData(URLs.animeURLAll.rawValue.getURLWithId(id)) { (anime: Anime?, error: AFError?) in
            if let anime = anime {
                self.anime = anime
                self.vc?.updateView()
            } else {
                self.vc?.setUpErrorView(message: error?.localizedDescription)
            }
            self.indicator.stopAnimating()
        }
    }
    
    func addToListClicked() {
        if let picker = vc?.storyboard?.instantiateViewController(withIdentifier: "MyAnimeStatusViewController") as? MyAnimeStatusViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            picker.anime = anime
            vc?.present(picker, animated: true)
        }
    }
    
    func selectedCollectionViewItem(at index: Int, cv: UICollectionView) {
        var type: ItemType = .anime
        var id: Int? = nil
        
        if cv == vc?.relatedMangaCollectionView {
            type = .manga
            id = anime?.relatedManga?[index].node.id
        }
        
        if cv == vc?.relatedAnimeCollectionView {
            type = .anime
            id = anime?.relatedAnime?[index].node.id
        }
        
        if cv == vc?.recommendationsCollectionView {
           // print("clicked rec")
            type = .anime
            id = anime?.recommendations?[index].node.id
        }
        
        switch type {
        case .anime:
            if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailViewController") as? AnimeDetailViewController {
                controller.id = id
                vc?.navigationController?.pushViewController(controller, animated: true)
            }
        case .manga:
            if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "MangaDetailViewController") as? MangaDetailViewController {
                controller.id = id
                vc?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func openingsEndingsButtonClicked() {
        if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "ThemesDetailViewController") as? ThemesDetailViewController {
         //   print("id is \(anime?.id)")
            controller.id = anime?.id
            vc?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func openMoreInformation() {
        if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "MoreInformationViewController") as? MoreInformationViewController {
         //   print("id is \(anime?.id)")
            controller.id = anime?.id
            vc?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tryAgainButtonClicked() {
        if anime?.title != nil, let id = id {
            fetchAnimeForId(id)
        }
    }
}

extension AnimeDetailViewModel: NetworkManagerDelegate {
    
    func connectionRestored() {
        if anime?.title != nil, let id = id {
            fetchAnimeForId(id)
        }
    }
    
}
