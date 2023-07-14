//
//  AnimelistViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import UIKit

class AnimelistViewModel {
    
    private var vc: AnimelistViewController? = nil
    private var urlManager = URLManager()
    private var userAnimelist: UserAnimelist? = nil
    private var loadingIndicator = ActivityIndicator()
    private var handler = AuthenticationHandler()
    
    private var availableStatuses: [SelectableView] = [
        SelectableView(name: "All", status: .none, isSelected: true),
        SelectableView(name: "Watching", status: .watching),
        SelectableView(name: "Plan to watch", status: .planToWatch),
        SelectableView(name: "Completed", status: .completed),
        SelectableView(name: "On hold", status: .onHold),
        SelectableView(name: "Dropped", status: .dropped)
    ]
    
    init() {}
    
    func viewDidLoad(vc: AnimelistViewController) {
        self.vc = vc
    }
    
    func viewWillAppear() {
        //TODO: make different check for view did load and then became active again
        checkStatusAndFetch()
    }
    
    private func checkStatusAndFetch() {
        guard let vc = vc else { return }
        if setUIIfLogged(vc: vc) {
            for availableStatus in availableStatuses { //if user logged, check which status is selected and fetch it
                if availableStatus.isSelected {
                    statusSelected(availableStatus.status)
                }
            }
        }
    }
    
    private func setUIIfLogged(vc: AnimelistViewController) -> Bool {
        print("if logged called")
        if TokenHandler.isUserLoggedIn {
            print("user logged in")
            vc.notLoggedView.isHidden = true
            loadingIndicator.startAnimating(view: vc.view, background: nil)
            return true
        } else {
            print("user not logged in")
            vc.notLoggedView.isHidden = false
            return false
        }
    }
    
    func statusSelected(_ status: UserAnimeStatus?) {
        let url = urlManager.getAnimelistURLForStatus(status)
        print("my url is \(url)")
        fetchAnimelist(url: url)
    }
    
    func getAvailableStatuses() -> [SelectableView] {
        return availableStatuses
    }
    
    func cellSelected(index: Int) {
        startLoadingAnimation()
        var previouslySelectedIndex = 0
        for i in 0...availableStatuses.count-1 {
            if availableStatuses[i].isSelected == true {
                previouslySelectedIndex = i
            }
        }
        availableStatuses[previouslySelectedIndex].isSelected = false
        availableStatuses[index].isSelected = true
        statusSelected(availableStatuses[index].status) //passed the status to fetch animer
        vc?.updateCollectionView()
    }
    
    func loginButtonClicked() {
        guard let vc = vc else { return }
        handler.authenticate(vc) {
            print("ALL DONE")
            self.setUIIfLogged(vc: vc)
        }
        
    }
    
    func tableViewItemSelectedAt(_ index: Int) {
        if let picker = vc?.storyboard?.instantiateViewController(withIdentifier: "AnimelistDetailViewController") as? AnimelistDetailViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.large()]
            }
            var anime = userAnimelist?.data[index].node
            anime?.myListStatus = userAnimelist?.data[index].list_status
            print("anime with list status \(anime?.myListStatus)")
            picker.anime = anime
            vc?.present(picker, animated: true)
        }
    }
    
    private func startLoadingAnimation() {
        guard let vc = vc else { return }
        vc.loadingOverlay.isHidden = false
        loadingIndicator.startAnimating(view: vc.view, background: .clear)
    }
    
    private func stopLoadingAnimation() {
        guard let vc = vc else { return }
        loadingIndicator.stopAnimating()
        vc.loadingOverlay.isHidden = true
    }
    
    private func fetchAnimelist(url: String) {
        DataDownloader.dataDownloader.fetchData(url) { (userList: UserAnimelist?) in
            if let list = userList {
                self.userAnimelist = userList
                self.vc?.updateTableViewWith(userList?.data)
                self.stopLoadingAnimation()
            } else {
                //TODO: stop loading and show info about not having an animelist
            }
        }
    }
    
}
