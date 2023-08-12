//
//  AnimelistDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.07.2023.
//

import UIKit
import Alamofire
import SkeletonView

class MyAnimeStatusModel {
    
    private var vc: MyAnimeStatusViewController? = nil
    private var anime: Anime?
    
    private let manager = UserAnimeStatusManager()
    private let dataDownloader = DataDownloader()
    private let urlManager = URLManager()
    private let skeletonManager = SkeletonManager()
    
    var selectedState: UserAnimeStatus? = nil
    var selectedPriority: Priority = .low
    
    var updatedAnimeStatus: MyAnimeListStatus? = nil
    
    let priorityList: [Priority] = [.low, .medium, .high]
    
    init() {}
    
    func viewDidLoad(vc: MyAnimeStatusViewController, anime: Anime) {
        skeletonManager.showSkeletonFor(vc.view)
        self.vc = vc
        self.anime = anime
        self.updatedAnimeStatus?.priority = selectedPriority
        fetchList()
    }
    
    private func fetchList() {
        guard let id = anime?.id else {
            vc?.showErrorDialog(message: "Something went wrong.")
            return
        }
        let url = urlManager.getURLForId(id, url: URLs.animeGetListURL.rawValue)
        //print("my url is \(url)")
        dataDownloader.fetchData(url) { (anime: Anime?, error: AFError?) in
            if let anime = anime {
                self.anime?.myListStatus = anime.myListStatus
                self.vc?.setUpUIWith(self.anime!)
            } else if let error = error {
                self.vc?.showErrorDialog(message: "Something went wrong.")
            }
            if let vc = self.vc {
                self.skeletonManager.hideSkeletonFor(vc.view)
            }
            self.setSelectedState()
        }
    }
    
    private func setSelectedState() {
        if let status = anime?.myListStatus {
            print("got status \(status.status)")
            let myListTag = manager.getTagForStatus(status.status)
            print("my list tag \(myListTag)")
            vc?.setSelectedState(for: myListTag)
            selectedState = manager.getStatusForTag(myListTag)
        } else {
            vc?.setSelectedState(for: manager.getTagForStatus(.planToWatch))
            selectedState = .planToWatch
        }
    }
    
    func buttonSelected(sender: UIButton) {
        if let previouslySelected = vc?.view.viewWithTag(manager.getTagForStatus(selectedState ?? .planToWatch)) as? UIButton {
            //print("previously selected \(previouslySelected.tag)")
            vc?.setUnselectedState(for: previouslySelected.tag) //unselecting previous button
            selectedState = manager.getStatusForTag(sender.tag) //selecting the new one
            //print("new selected \(sender.tag)")
            vc?.setSelectedState(for: sender.tag)
        }
    }
    
    func saveButtonClicked() {
        
        guard let vc = vc else { return }

        updatedAnimeStatus = MyAnimeListStatus(status: selectedState ?? .planToWatch,
                                               score: (Int(vc.itemScoreLabel.text ?? "0")) ?? 0,
                                               episodesWatchedCount: Int(vc.itemEpisodesWatchedLabel.text ?? "0"),
                                               finishDate: nil,
                                               priority: selectedPriority)
        
        
        if let id = anime?.id {
            let url = urlManager.getURLForId(id, url: URLs.animeListStatusURL.rawValue)
            dataDownloader.changeAnimeList(url, params: updatedAnimeStatus!, completion: {
                //print("All done = anime")
                self.vc?.dismiss(animated: true)
            })
        }
    }
    
    func cancelButtonClicked() {
        vc?.dismiss(animated: true)
    }
    
    func removeButtonClicked() {
        var url = URLs.animeListStatusURL.rawValue
        if let id = anime?.id {
            url = urlManager.getURLForId(id, url: url)
            dataDownloader.deleteList(url, completion: {
                //print("All deleted")
                self.vc?.dismiss(animated: true)
            })
        }
    }
    
    func moreDetailsButtonClicked() {
        //TODO: push a new vc with details, if user changed something pass it into the vc
    }
    
    func priorityChangedTo(_ priority: Priority) {
        selectedPriority = priority
    }
    
    
    
}
