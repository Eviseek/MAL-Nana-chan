//
//  ThemesDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.08.2023.
//

import Foundation
import Alamofire

class ThemesDetailViewModel {
    
    private var vc: ThemesDetailViewController? = nil
    private var id: Int? = nil
    
    private let dataDownloader = DataDownloader()
    private let urlManager = URLManager()
    private let networkManager = NetworkManager.shared
    private let indicator = ActivityIndicator()
    
    var themes: Themes? = nil
    
    init() {}
    
    func viewDidLoad(vc: ThemesDetailViewController, id: Int) {
        indicator.startAnimating(view: vc.view)
        self.vc = vc
        self.id = id
        networkManager.reachabilityDelegate = self
        fetchThemes(id: id)
    }
    
    private func fetchThemes(id: Int) {
        dataDownloader.fetchData(urlManager.getURLForId(id, url: URLs.jikanThemesURL.rawValue)) { (result: Theme?, error: AFError?) in
            if let data = result?.data {
                self.themes = data
                print("themes are \(self.themes)")
                self.vc?.fillTableViewWith(self.themes!)
            } else {
                self.vc?.setUpErrorView(message: error?.localizedDescription)
            }
            self.indicator.stopAnimating()
        }
    }
    
    func tryAgainButtonClicked() {
        if themes == nil {
            if let id = id {
                fetchThemes(id: id)
            }
        }
    }
    
}

extension ThemesDetailViewModel: NetworkManagerDelegate {
    
    func connectionRestored() {
        if themes == nil {
            if let id = id {
                fetchThemes(id: id)
            }
        }
    }
    
}
