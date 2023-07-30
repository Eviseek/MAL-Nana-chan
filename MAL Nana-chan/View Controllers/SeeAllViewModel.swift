//
//  SeeAllViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.06.2023.
//

import UIKit


//TODO: paging!

class SeeAllViewModel<T: Codable> {
    
    //for loading animation
    private let indicator = ActivityIndicator()
    
    private var vc: SeeAllViewController<T>? = nil
    private var section: Section<T>? = nil
    
    private var animeSection: Section<Anime>? = nil
    private var mangaSection: Section<Manga>? = nil
    
    private var dataDownloader = DataDownloader()
    private var fields = ["mean", "media_type", "status", "num_episodes", "source", "start_season", "my_list_status"]
    
    private var mainStoryboard = UIStoryboard()
    
    private var nextPage: String? = nil
    var isFetching = false
    
    
    init() {}
    
    func viewDidLoad(viewController: SeeAllViewController<T>, section: Section<T>) {
        indicator.startAnimating(view: viewController.view, background: nil)
        self.vc = viewController
        self.section = section
        self.nextPage = section.response.paging?.next
        fillSectionByType()
        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        indicator.stopAnimating()
    }
    
    private func fillSectionByType() {
        if section?.type == .anime {
            self.animeSection = section as? Section<Anime>
            if let data = animeSection?.response.data {
                vc?.fillTableView(anime: data)
            }
        } else if section?.type == .manga {
            self.mangaSection = section as? Section<Manga>
            if let data = mangaSection?.response.data {
                vc?.fillTableView(manga: data)
            }
        }
    }
    
    func itemSelectedAt(_ index: Int) {
        if section?.type == .anime {
            if let controller = mainStoryboard.instantiateViewController(withIdentifier: "AnimeDetailViewController") as? AnimeDetailViewController {
                controller.id = animeSection?.response.data[index].node.id
                vc?.navigationController?.pushViewController(controller, animated: true)
            }
        } else if section?.type == .manga {
            if let controller = mainStoryboard.instantiateViewController(withIdentifier: "MangaDetailViewController") as? MangaDetailViewController {
                controller.id = mangaSection?.response.data[index].node.id
                vc?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func scrolledToBottom() {
        if let nextPage = nextPage {
            self.isFetching = true
            fetchData(url: nextPage, completion: {
                self.isFetching = false
                self.fillSectionByType()
            })
        }
    }
    
    private func fetchData(url: String, completion: @escaping () -> ()) {
        if section?.type == .anime {
            DataDownloader.dataDownloader.fetchData(url, completion: { (result: Response<Anime>?) in
                if let result = result {
                    self.animeSection?.response.data.append(contentsOf: result.data)
                    self.animeSection?.response.paging = result.paging
                    self.nextPage = self.animeSection?.response.paging?.next ?? nil
                    completion()
                } else {
                    self.vc?.showErrorDialog(message: "Something went wrong.")
                    completion()
                    return
                }
                
            })
        } else if section?.type == .manga {
            DataDownloader.dataDownloader.fetchData(url, completion: { (result: Response<Manga>?) in
                if let result = result {
                    self.mangaSection?.response.data.append(contentsOf: result.data)
                    self.mangaSection?.response.paging = result.paging
                    self.nextPage = self.mangaSection?.response.paging?.next ?? nil
                    completion()
                } else {
                    self.vc?.showErrorDialog(message: "Something went wrong.")
                    completion()
                    return
                }
            })
        }
    }
    
}
