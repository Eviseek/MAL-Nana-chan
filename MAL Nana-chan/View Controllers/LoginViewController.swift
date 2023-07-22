//
//  LoginViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 01.07.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var viewModel = LoginViewModel()
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(self)
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        viewModel.loginButtonClicked()
    }
    
}
