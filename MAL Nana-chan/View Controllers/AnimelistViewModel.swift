//
//  AnimelistViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation

class AnimelistViewModel {
    
    private var vc: AnimelistViewController? = nil
    private var urlManager = URLManager()
    private var userAnimelist: UserAnimelist? = nil
    
    private var availableStatuses: [SelectableView] = [
        SelectableView(name: "All", isSelected: true),
        SelectableView(name: "Watching"),
        SelectableView(name: "Plan to watch"),
        SelectableView(name: "Completed"),
        SelectableView(name: "On hold"),
        SelectableView(name: "Dropped")
    ]
    
    init() {}
    
    func viewDidLoad(vc: AnimelistViewController) {
        self.vc = vc
        fetchAnimelist(url: URLs.myAnimelistURL.rawValue)
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
        var previouslySelectedIndex = 0
        for i in 0...availableStatuses.count-1 {
            if availableStatuses[i].isSelected == true {
                previouslySelectedIndex = i
            }
        }
        availableStatuses[previouslySelectedIndex].isSelected = false
        availableStatuses[index].isSelected = true
        print("available status \(availableStatuses)")
        vc?.updateCollectionView()
    }
    
    private func fetchAnimelist(url: String) {
        DataDownloader.dataDownloader.fetchData(url) { (userList: UserAnimelist?) in
            if let list = userList {
                self.userAnimelist = userList
                self.vc?.updateTableViewWith(userList?.data)
            } else {
                //TODO: stop loading and show info about not having an animelist
            }
        }
    }
    
}
