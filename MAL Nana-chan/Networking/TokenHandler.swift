//
//  TokenHandler.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation
import KeychainAccess

class TokenHandler {
    
    public static var isUserLoggedIn: Bool = false
    static let handler = TokenHandler()
    var keychain: Keychain
    
    init() {
        keychain = Keychain(service: "com.eviseek.MAL-Nana-chan")
        if let token = getToken() {
            TokenHandler.isUserLoggedIn = true
        } else {
            TokenHandler.isUserLoggedIn = false
        }
    }
    
    private func requestNewToken() {
        
    }
    
    private func checkToken() {
        
    }
    
    func saveToken(_ token: String) {
        keychain[Identifiers.keychainToken.rawValue] = token
        TokenHandler.isUserLoggedIn = true
    }
    
    func deleteToken() {
        try? keychain.remove(Identifiers.keychainToken.rawValue)
        TokenHandler.isUserLoggedIn = false
    }
    
    func getToken() -> String? {
        return keychain[Identifiers.keychainToken.rawValue]
    }
    
}
