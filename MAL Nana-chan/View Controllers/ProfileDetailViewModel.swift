//
//  ProfileDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 17.07.2023.
//

import Foundation
import Alamofire

class ProfileDetailViewModel {
    
    private var vc: ProfileDetailViewController?
    private var user: User? = nil
    private var indicator = ActivityIndicator()
    
    init() {}
    
    func viewDidLoad(vc: ProfileDetailViewController) {
        self.vc = vc
        indicator.startAnimating(view: vc.view)
        fetchMyProfile()
    }
    
    func logOutButtonClicked() {
        TokenHandler.handler.deleteToken()
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    private func fetchMyProfile() {
        DataDownloader.dataDownloader.fetchData(URLs.myUserProfileURL.rawValue) { (user: User?, error: AFError?) in
            if let user = user {
                self.user = user
                self.vc?.updateViewWith(user)
            } else {
                self.vc?.noData()
            }
            self.indicator.stopAnimating()
        }
    }
    
}
