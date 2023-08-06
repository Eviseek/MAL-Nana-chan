//
//  MoreInformationViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.08.2023.
//

import Foundation
import Alamofire

class MoreInformationViewModel {
    
    private var vc: MoreInformationViewController? = nil
    private var id: Int? = nil
    
    private let dataDownloader = DataDownloader()
    private let urlManager = URLManager()
    private let indicator = ActivityIndicator()
    
    private var information: Information? = nil
    
    init() {}
    
    func viewDidLoad(vc: MoreInformationViewController, id: Int) {
        indicator.startAnimating(view: vc.view)
        self.vc = vc
        self.id = id
        fetchInformation(id: id)
    }
    
    private func fetchInformation(id: Int) {
        dataDownloader.fetchData(urlManager.getURLForId(id, url: URLs.jikanMoreInfoURL.rawValue)) { (result: MoreInformation?, error: AFError?) in
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
