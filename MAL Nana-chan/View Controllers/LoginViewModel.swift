//
//  LoginViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 01.07.2023.
//

import Foundation

class LoginViewModel {
    
    private var loginVC: LoginViewController?
    private var handler = AuthenticationHandler()
    
    
    init(loginVC: LoginViewController? = nil) {
        self.loginVC = loginVC
    }
    
    func viewDidLoad(_ vc: LoginViewController) {
        self.loginVC = vc
    }
    
    func loginButtonClicked() {
        if let loginVC = loginVC {
            handler.authenticate(loginVC) {
                //TODO: update screen
            }
        }
    }
    
}
