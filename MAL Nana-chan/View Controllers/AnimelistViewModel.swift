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
        setUpIfLogged(vc: vc)
    }
    
    func viewWillAppear() {
        if let vc = vc {
            setUpIfLogged(vc: vc)
        }
    }
    
    private func setUpIfLogged(vc: AnimelistViewController) {
        if TokenHandler.isUserLoggedIn {
            vc.notLoggedView.isHidden = true
            loadingIndicator.startAnimating(view: vc.view, background: nil)
            fetchAnimelist(url: URLs.myAnimelistURL.rawValue)
        } else {
            vc.notLoggedView.isHidden = false
        }
    }
    
    func statusSelected(_ status: UserAnimeStatus?) {
        if let status = status {
            let url = urlManager.getAnimelistURLForStatus(status)
            fetchAnimelist(url: url)
        } else {
            //to fetch everything
            fetchAnimelist(url: URLs.myAnimelistURL.rawValue)
        }
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
        handler.authenticate(vc)
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
