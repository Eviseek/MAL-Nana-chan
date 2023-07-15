//
//  AnimelistDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.07.2023.
//

import Foundation
import UIKit

class AnimelistDetailViewModel {
    
    private var vc: AnimelistDetailViewController? = nil
    private var anime: Anime?
    private var manager = UserAnimeStatusManager()
    var selectedState: UserAnimeStatus? = nil
    
    init() {}
    
    func viewDidLoad(vc: AnimelistDetailViewController, anime: Anime) {
        self.vc = vc
        self.anime = anime
        setSelectedState()
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
            print("previously selected \(previouslySelected.tag)")
            vc?.setUnselectedState(for: previouslySelected.tag) //unselecting previous button
            selectedState = manager.getStatusForTag(sender.tag) //selecting the new one
            print("new selected \(sender.tag)")
            vc?.setSelectedState(for: sender.tag)
        }
    }
    
    func saveButtonClicked() {
        
        let stringUrl = URLs.patchAnimelistURL.rawValue
        let urlWithId = stringUrl.replacingOccurrences(of: "{id}", with: anime?.id.description ?? "0")
        print("my url is \(urlWithId)")
        
        let updatedStatus = MyListStatus(status: selectedState ?? .planToWatch, score: 0, episodesWatchedCount: 0, finishDate: nil)

        DataDownloader.dataDownloader.changeList(urlWithId, params: updatedStatus) {
            print("all done")
        }
       
    }
    
    func cancelButtonClicked() {
        vc?.dismiss(animated: true)
    }
    
    func removeButtonClicked() {
        //TODO: show dialog, if clicked yes then set listStatus to nil and send it to MAL
    }
    
    func moreDetailsButtonClicked() {
        //TODO: push a new vc with details, if user changed something pass it into the vc
    }
    
    
    
}
