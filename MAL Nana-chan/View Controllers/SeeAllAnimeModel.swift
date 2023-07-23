//
//  SeeAllViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.06.2023.
//

import Foundation


//TODO: paging!

class SeeAllAnimeModel {
    
    //for loading animation
    private let indicator = ActivityIndicator()
    
    private var vc: SeeAllAnimeViewController? = nil
    private var sectionContent: Section<Anime>? = nil
    
    private var dataDownloader = DataDownloader()
    private var fields = ["mean", "media_type", "status", "num_episodes", "source", "start_season", "my_list_status"]
    
    private var animeArr = [Anime]()
    
    private var nextPage: String? = nil
    
    
    init() {}
    
    func viewDidLoad(viewController: SeeAllAnimeViewController, content: Section<Anime>) {
        self.vc = viewController
        self.sectionContent = content
        indicator.startAnimating(view: viewController.view, background: nil)
        dataDownloader = DataDownloader()
    }
    
    func itemSelectedAt(_ index: Int) {
        if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailViewController") as? AnimeDetailViewController {
            controller.id = animeArr[index].id
            vc?.navigationController?.pushViewController(controller, animated: true)
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
    
    private func fetchData(url: String, completion: @escaping (Response<Anime>) -> ()) {
        DataDownloader.dataDownloader.fetchData(url, completion: { (result: Response<Anime>?) in
            if let data = result?.data {
                //creating a new array so I can pass all anime to view controller
                for single in data {
                    self.animeArr.append(single.node)
                }
                self.vc?.fillTableView(items: self.animeArr) { //stop the loading animation once data passed
                    self.indicator.stopAnimating()
                }
            } else {
                self.vc?.showErrorDialog(message: "Something went wrong.")
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
