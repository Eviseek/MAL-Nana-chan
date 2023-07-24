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
    
    private var nextPage: String? = nil
    
    
    init() {}
    
    func viewDidLoad(viewController: SeeAllViewController<T>, section: Section<T>) {
        self.vc = viewController
        self.section = section
        setUpSectionAccordingToType()
        indicator.startAnimating(view: viewController.view, background: nil)
    }
    
    private func setUpSectionAccordingToType() {
        if section?.type == .anime {
            vc?.animeTableViewSetUp()
            self.animeSection = section as? Section<Anime>
            if let data = animeSection?.response.data {
                vc?.fillTableView(anime: data)
            }
        } else if section?.type == .manga {
            vc?.mangaTableViewSetUp()
            self.mangaSection = section as? Section<Manga>
            if let data = mangaSection?.response.data {
                vc?.fillTableView(manga: data)
            }
        }
        indicator.stopAnimating()
    }
    
    func itemSelectedAt(_ index: Int) {
        if section?.type == .anime {
            if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailViewController") as? AnimeDetailViewController {
                controller.id = animeSection?.response.data[index].node.id
                vc?.navigationController?.pushViewController(controller, animated: true)
            }
        } else if section?.type == .manga {
            if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "MangaDetailViewController") as? MangaDetailViewController {
                controller.id = mangaSection?.response.data[index].node.id
                vc?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func scrolledToBottom() {
        if let nextPage = nextPage {
            getPagingData(url: nextPage)
        }
    }
    
    private func getPagingData(url: String) {
//        fetchData(url: url) { list in
//            if let list = list {
//                self.animeArr?.data.append(contentsOf: list.data)
//                print("my list is \(list.data.count)")
//                self.userAnimelist?.paging = list.paging
//                if let nextPage = list.paging?.next {
//                    self.nextPage = nextPage
//                    print("next page is \(nextPage)")
//                } else {
//                    self.nextPage = nil
//                }
//                self.vc?.updateTableViewWith(self.userAnimelist?.data, scrollToTop: false)
//                self.stopLoadingAnimation()
//            }
//            self.isFetching = false
//        }
    }
    
    private func fetchData(url: String, completion: @escaping (Response<T>) -> ()) {
        if section?.type == .anime {
            DataDownloader.dataDownloader.fetchData(url, completion: { (result: Response<Anime>?) in
                if let result = result {
                    self.animeSection?.response.data.append(contentsOf: result.data)
                    self.animeSection?.response.paging = result.paging
                    //  self.vc?.fillTableView(items: self.animeArr) { //stop the loading animation once data passed
                    //  self.indicator.stopAnimating()
                } else {
                    self.vc?.showErrorDialog(message: "Something went wrong.")
                    return
                }
            })
        } else if section?.type == .manga {
            DataDownloader.dataDownloader.fetchData(url, completion: { (result: Response<Manga>?) in
                if let result = result {
                    self.mangaSection?.response.data.append(contentsOf: result.data)
                    self.mangaSection?.response.paging = result.paging
                  //  self.vc?.fillTableView(items: self.animeArr) { //stop the loading animation once data passed
                  //  self.indicator.stopAnimating()
                } else {
                    self.vc?.showErrorDialog(message: "Something went wrong.")
                    return
                }
            })
        }
    }
    
//    private func getCleanUrl(url: String) -> String {
//        var changedUrl = url
//        if let questionMarkRange = url.range(of: "=") { //fields=
//            changedUrl.removeSubrange(questionMarkRange.lowerBound..<url.endIndex)
//            print("my new url \(changedUrl)")
//        }
//        
//        return changedUrl
//    }
//    
//    private func appendFields(fields: [String], url: String) -> String {
//        
//        var changedUrl = getCleanUrl(url: url)
//        changedUrl += "="
//        
//        for i in 0...fields.count-1 {
//            changedUrl += fields[i]
//            if i != fields.count-1 {
//                changedUrl += ","
//            }
//        }
//        print("new url \(changedUrl)")
//        
//        return changedUrl
//    }
    
}
