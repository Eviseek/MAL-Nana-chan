//
//  AnimelistDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.07.2023.
//

import Foundation

class AnimelistDetailViewModel {
    
    private var vc: AnimelistDetailViewController? = nil
    private var anime: Anime?
    var selectedState: UserAnimeStatus = .planToWatch
    
    init() {}
    
    func viewDidLoad(vc: AnimelistDetailViewController, anime: Anime) {
        self.vc = vc
        self.anime = anime
        extractListStatus()
    }
    
    private func extractListStatus() {
        if let status = anime?.myListStatus {
            //TODO: set up from values
            //vc?.changeButtonsState(<#T##Int#>)
        }
    }
    
}
