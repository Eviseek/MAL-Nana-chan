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
    private var nextPage: String? = nil
    var isFetching: Bool = false
    
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
        getAnimelistData(url: url)
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
        if let picker = vc?.storyboard?.instantiateViewController(withIdentifier: "MyListViewController") as? MyListViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.large()]
            }
            var anime = userAnimelist?.data[index].node
            anime?.myListStatus = userAnimelist?.data[index].list_status
         //   print("anime with list status \(anime?.myListStatus)")
            picker.anime = anime
            picker.fromAnimelist = true
            vc?.present(picker, animated: true)
        }
    }
    
    func scrolledToBottom() {
        if let nextPage = nextPage {
            getPagingData(url: nextPage)
        }
    }
    
    private func getPagingData(url: String) {
        fetchAnimelist(url: url) { list in
            if let list = list {
                self.userAnimelist?.data.append(contentsOf: list.data)
                print("my list is \(list.data.count)")
                self.userAnimelist?.paging = list.paging
                if let nextPage = list.paging?.next {
                    self.nextPage = nextPage
                    print("next page is \(nextPage)")
                } else {
                    self.nextPage = nil
                }
                self.vc?.updateTableViewWith(self.userAnimelist?.data, scrollToTop: false)
                self.stopLoadingAnimation()
            }
            self.isFetching = false
        }
    }
    
    private func getAnimelistData(url: String) {
        fetchAnimelist(url: url) { list in
            if let list = list {
                self.userAnimelist = list
                self.vc?.updateTableViewWith(self.userAnimelist?.data, scrollToTop: true)
                self.stopLoadingAnimation()
                if let nextPage = list.paging?.next {
                    self.nextPage = nextPage
                    print("next page is \(nextPage)")
                } else {
                    self.nextPage = nil
                }
            } else {
                print("no items in this list")
                //TODO: stop loading and show info about not having an animelist
            }
            self.isFetching = false
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
    
    private func fetchAnimelist(url: String, completion: @escaping (UserAnimelist?) -> Void) {
        if !isFetching {
            print("fetching")
            isFetching = true
            DataDownloader.dataDownloader.fetchData(url) { (userList: UserAnimelist?) in
                if let list = userList {
                    completion(list)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
}
