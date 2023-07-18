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
        if !TokenHandler.isUserLoggedIn {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewController") as? ProfileDetailViewController {
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
