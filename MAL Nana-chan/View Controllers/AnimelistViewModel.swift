//
//  AnimelistViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import UIKit
import Alamofire

class AnimelistViewModel {
    
    private var vc: AnimelistViewController? = nil
    private var urlManager = URLManager()
    private var userAnimelist: UserAnimelist? = nil
    private var loadingIndicator = ActivityIndicator()
    private var handler = AuthenticationHandler()
    private var nextPage: String? = nil
    var isFetching: Bool = false
    
    private var networkManager = NetworkManager.shared
    
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
        self.networkManager.reachabilityDelegate = self
    }
    
    func viewWillAppear() {
        if userAnimelist == nil {
            //TODO: make different check for view did load and then became active again
            checkStatusAndFetch()
        }
    }
    
    func tryAgainButtonClicked() {
        checkStatusAndFetch()
    }
    
    private func checkStatusAndFetch() {
        guard let vc = vc else { return }
        if setUIIfLogged(vc: vc) {
            for availableStatus in availableStatuses { //if user logged, check which status is selected and fetch it
                if availableStatus.isSelected {
                    getAnimelistData(status: availableStatus.status)
                }
            }
        }
    }
    
    private func setUIIfLogged(vc: AnimelistViewController) -> Bool {
        print("if logged called")
        if TokenHandler.isUserLoggedIn {
            print("user logged in")
            vc.notLoggedView.isHidden = true
            loadingIndicator.startAnimating(view: vc.view)
            return true
        } else {
            print("user not logged in")
            vc.notLoggedView.isHidden = false
            return false
        }
    }
    
    func getAvailableStatuses() -> [SelectableView] {
        return availableStatuses
    }
    
    func statusSelected(index: Int) {
        startLoadingAnimation()
        var previouslySelectedIndex = 0
        for i in 0...availableStatuses.count-1 {
            if availableStatuses[i].isSelected == true {
                previouslySelectedIndex = i
            }
        }
        availableStatuses[previouslySelectedIndex].isSelected = false
        availableStatuses[index].isSelected = true
        getAnimelistData(status: availableStatuses[index].status) //passed the status to fetch animer
        vc?.updateCollectionView()
    }
    
    func loginButtonClicked() {
        guard let vc = vc else { return }
        handler.authenticate(vc) {
            self.setUIIfLogged(vc: vc)
        }
        
    }
    
    func tableViewItemSelectedAt(_ index: Int) {
        if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailViewController") as? AnimeDetailViewController {
            var anime = userAnimelist?.data[index].node
            controller.id = anime?.id
            vc?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func scrolledToBottom() {
        if let nextPage = nextPage {
            getPagingData(url: nextPage)
        }
    }
    
    private func getPagingData(url: String) {
        fetchAnimelist(url: url) { list, error in
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
            }
            self.isFetching = false
        }
        self.stopLoadingAnimation()
    }
    
    private func getAnimelistData(status: UserAnimeStatus?) {
        fetchAnimelist(url: urlManager.getAnimelistURLForStatus(status)) { list, error in
            if let list = list {
                if list.data.count > 0 {
                   print("!!!!!!!!!!!!! first item is \(list.data[0])")
                    self.userAnimelist = list
                  //  print("!!!!!!!!!!!!!! userAnimelist \(self.userAnimelist?.data[0])")
                    self.vc?.updateTableViewWith(self.userAnimelist?.data, scrollToTop: true)
                    if let nextPage = list.paging?.next {
                        self.nextPage = nextPage
                        print("next page is \(nextPage)")
                    } else {
                        self.nextPage = nil
                    }
                } else {
                    self.vc?.setUpEmptyList()
                }
            } else {
                self.vc?.setUpErrorView(message: error ?? "No description.")
            }
            self.isFetching = false
        }
        self.stopLoadingAnimation()
    }
    
    private func startLoadingAnimation() {
        guard let vc = vc else { return }
        loadingIndicator.startAnimating(view: vc.view)
    }
    
    private func stopLoadingAnimation() {
        guard let vc = vc else { return }
        loadingIndicator.stopAnimating()
    }
    
    private func fetchAnimelist(url: String, completion: @escaping (UserAnimelist?, String?) -> Void) {
        if !isFetching {
            print("fetching")
            isFetching = true
            DataDownloader.dataDownloader.fetchData(url) { (userList: UserAnimelist?, error: AFError?) in
                if let list = userList {
                    completion(list, nil)
                } else {
                    completion(nil, error?.localizedDescription)
                }
            }
        }
    }
    
}

extension AnimelistViewModel: NetworkManagerDelegate {
    
    func connectionRestored() {
        if userAnimelist == nil {
            checkStatusAndFetch()
        }
    }
    
}
