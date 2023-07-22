//
//  LoginViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 01.07.2023.
//

import Foundation

class LoginViewModel {
    
    private var vc: LoginViewController?
    private var handler = AuthenticationHandler()
    
    
    init(loginVC: LoginViewController? = nil) {
        self.vc = loginVC
    }
    
    func viewDidLoad(_ vc: LoginViewController) {
        self.vc = vc
    }
    
    func loginButtonClicked() {
        if let loginVC = vc {
            handler.authenticate(loginVC) {
                self.vc?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
