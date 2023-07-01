//
//  TabBarController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 01.07.2023.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func profileButtonClicked(_ sender: UIBarButtonItem) {
        print("selected")
        //TODO: redirect to login screen
    }
}
