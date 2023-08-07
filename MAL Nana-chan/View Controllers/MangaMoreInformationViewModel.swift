//
//  MangaMoreInformationViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 07.08.2023.
//

import Foundation
import Alamofire

class MangaMoreInformationViewModel {
    
    private var vc: MangaMoreInformationViewController? = nil
    private var id: Int? = nil
    private var information: MangaInformation? = nil
    
    private let indicator = ActivityIndicator()
    private let dataDownloader = DataDownloader()
    private let urlManager = URLManager()
    
    init() {}
    
    func viewDidLoad(vc: MangaMoreInformationViewController, id: Int) {
        indicator.startAnimating(view: vc.view)
        self.vc = vc
        self.id = id
        fetchInformation(id: id)
    }
    
    private func fetchInformation(id: Int) {
        dataDownloader.fetchData(urlManager.getURLForId(id, url: URLs.jikanMangaMoreInfoURL.rawValue)) { (result: MangaMoreInformation?, error: AFError?) in
            if let data = result?.data {
                self.information = data
                self.vc?.setUpUIWith(self.information!)
            } else {
                self.vc?.showErrorView(message: error?.localizedDescription ?? "No description available.")
            }
            self.indicator.stopAnimating()
        }
        
    }
    
}
