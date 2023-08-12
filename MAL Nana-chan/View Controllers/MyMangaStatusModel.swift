//
//  MyMangaStatusModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.07.2023.
//

import UIKit
import Alamofire

class MyMangaStatusModel {
    
    private var vc: MyMangaStatusViewController? = nil
    private var manga: Manga?
    
    private let manager = UserMangaStatusManager()
    private let urlManager = URLManager()
    private let dataDownloader = DataDownloader()
    private let skeletonManager = SkeletonManager()
    
    private var updatedMangaStatus: MyMangaListStatus? = nil
    
    var selectedState: UserMangaStatus? = nil
    var selectedPriority: Priority = .low
    
    private let activityIndicator = ActivityIndicator()
    
    init() {}
    
    func viewDidLoad(vc: MyMangaStatusViewController, manga: Manga) {
        self.vc = vc
        self.manga = manga
        self.updatedMangaStatus?.priority = selectedPriority
        skeletonManager.showSkeletonFor(vc.view)
        fetchList()
    }
    
    private func fetchList() {
        guard let id = manga?.id else { return }
        let url = urlManager.getURLForId(id, url: URLs.mangaGetListURL.rawValue)
        dataDownloader.fetchData(url) { (manga: Manga?, error: AFError?) in
            if let manga = manga {
                self.manga?.myListStatus = manga.myListStatus
                self.vc?.setUIWith(self.manga!)
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
        if let status = manga?.myListStatus {
            //print("got status \(status.status)")
            let myListTag = manager.getTagForStatus(status.status)
            //print("my list tag \(myListTag)")
            vc?.setSelectedState(for: myListTag)
            selectedState = manager.getStatusForTag(myListTag)
        } else {
            vc?.setSelectedState(for: manager.getTagForStatus(.planToRead))
            selectedState = .planToRead
        }
    }
    
    func buttonSelected(sender: UIButton) {
        if let previouslySelected = vc?.view.viewWithTag(manager.getTagForStatus(selectedState ?? .planToRead)) as? UIButton {
            //print("previously selected \(previouslySelected.tag)")
            vc?.setUnselectedState(for: previouslySelected.tag) //unselecting previous button
            selectedState = manager.getStatusForTag(sender.tag) //selecting the new one
            //print("new selected \(sender.tag)")
            vc?.setSelectedState(for: sender.tag)
        }
    }
    
    func saveButtonClicked() {
        
        guard let vc = vc else { return }

        updatedMangaStatus = MyMangaListStatus(status: selectedState ?? .planToRead,
                                        score: (Int(vc.scoreLabel.text ?? "0")) ?? 0,
                                        volumesReadCount: Int(vc.mangaVolumesNumLabel.text ?? "0"),
                                        chaptersReadCount: Int(vc.mangaChaptersNumLabel.text ?? "0"),
                                        finishDate: nil)
        
        //print("my manga list is \(updatedMangaStatus)")
        
        if let id = manga?.id {
            let url = urlManager.getURLForId(id, url: URLs.mangaListStatusURL.rawValue)
            dataDownloader.changeMangaList(url, params: updatedMangaStatus!, completion: {
                print("All done = manga")
                //print("my manga status \(self.updatedMangaStatus)")
                self.vc?.dismiss(animated: true)
            })
        }
    }
    
    func cancelButtonClicked() {
        vc?.dismiss(animated: true)
    }
    
    func removeButtonClicked() {
        var url = URLs.mangaListStatusURL.rawValue
        if let id = manga?.id {
            url = urlManager.getURLForId(id, url: url)
            dataDownloader.deleteList(url, completion: {
                print("All deleted")
                self.vc?.dismiss(animated: true)
            })
        }
    }
    
    func moreDetailsButtonClicked() {
        //TODO: push a new vc with details, if user changed something pass it into the vc
    }
    
    func pickerViewChanged(_ priority: Priority) {
        selectedPriority = priority
    }
    
}
