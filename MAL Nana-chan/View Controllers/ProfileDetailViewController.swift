//
//  ProfileDetailViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 17.07.2023.
//

import Foundation
import UIKit
import AlamofireImage

class ProfileDetailViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var joinedAtLabel: UILabel!
    
    private var viewModel = ProfileDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(vc: self)
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
    }
    
    func updateViewWith(_ profile: User) {
        usernameLabel.text = profile.name
        if let url = URL(string: profile.picture ?? "") {
            userImageView.af.setImage(withURL: url)
        }
        genderLabel.text = profile.gender ?? "Not specified."
        birthdayLabel.text = profile.birthday?.convertToReadableDateString(originalFormat: "yyyy-mm-dd") ?? "Not specified."
        joinedAtLabel.text = profile.joinedAt.convertToReadableDateString(originalFormat: "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ")
    }
    
    func noData() {
        //TODO: show alert dialog and dismiss screen
    }
    
    
    @IBAction func appSettingsButtonClicked(_ sender: UIButton) {
        
        
    }
    
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        viewModel.logOutButtonClicked()
    }
    
}
