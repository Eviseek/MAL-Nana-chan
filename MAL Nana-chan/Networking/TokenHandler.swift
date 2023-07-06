//
//  TokenHandler.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation
import KeychainAccess

class TokenHandler {
    
    static let handler = TokenHandler()
    var keychain: Keychain
    
    init() {
        keychain = Keychain(service: "com.eviseek.MAL-Nana-chan")
    }
    
    private func requestNewToken() {
        
    }
    
    private func checkToken() {
        
    }
    
    func saveToken(_ token: String) {
        keychain[Identifiers.keychainToken.rawValue] = token
    }
    
    func getToken() -> String? {
        return keychain[Identifiers.keychainToken.rawValue]
    }
    
}
