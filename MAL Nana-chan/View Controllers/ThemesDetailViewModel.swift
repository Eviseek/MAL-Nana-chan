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

        // DISABLED 2026-08-08 — Jikan's /anime/{id}/themes returns 504 (see URLs.swift).
        //
        // Showing the existing error view rather than just deleting the call, so
        // the screen doesn't sit on a spinner forever. The "try again" button
        // still works and will start succeeding the moment the endpoint is
        // re-enabled above.
        indicator.stopAnimating()
        vc?.setUpErrorView(message: "Theme songs are temporarily unavailable.")

        // dataDownloader.fetchData(urlManager.getURLForId(id, url: URLs.jikanThemesURL.rawValue)) { (result: Theme?, error: AFError?) in
        //     if let data = result?.data {
        //         self.themes = data
        //         self.vc?.fillTableViewWith(self.themes!)
        //     } else {
        //         self.vc?.setUpErrorView(message: error?.localizedDescription)
        //     }
        //     self.indicator.stopAnimating()
        // }
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
