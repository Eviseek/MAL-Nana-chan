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
   // private var isTokenValid: Bool
    static let handler = TokenHandler()
    var keychain: Keychain
    
    init() {
        print("token handler init called")
        
        keychain = Keychain(service: "com.eviseek.MAL-Nana-chan")
        
        checkExpiration()
        
        if let _ = getToken() {
            TokenHandler.isUserLoggedIn = true
        } else {
            TokenHandler.isUserLoggedIn = false
        }
    }
    
    private func requestNewToken() {
        
    }
    
    private func checkExpiration() {
        let expiresAt = try? keychain.get(Identifiers.tokenExpirationDate.rawValue)
        if let expiresAt = expiresAt {
            if let expiresAtDate = expiresAt.convertToDate() {
                if Date() >= expiresAtDate {
                    deleteToken()
                } else {
                    print("expired not yet")
                }
            }
        }
    }
    
    func saveToken(_ token: String, expiresAt: Date?) {
        keychain[Identifiers.tokenExpirationDate.rawValue] = expiresAt?.convertToString(originalFormat: "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ")
        keychain[Identifiers.keychainToken.rawValue] = token
        TokenHandler.isUserLoggedIn = true
    }
    
    func deleteToken() {
        try? keychain.remove(Identifiers.tokenExpirationDate.rawValue)
        try? keychain.remove(Identifiers.keychainToken.rawValue)
        TokenHandler.isUserLoggedIn = false
    }
    
    func getToken() -> String? {
        return keychain[Identifiers.keychainToken.rawValue]
    }
    
}
