//
//  Authentication.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 18.07.2023.
//

import Foundation
import Alamofire
import OAuthSwift

//TODO: sometime in the future custom oauth2

class Authentication {
    
    func authenticate() {
        
        guard let codeVerifier = generateCodeVerifier() else { return }
        let codeChallenge = codeVerifier
        
        var parameters = [
            "response_type": "code",
            "client_id": "f46d47449490d772ff01a31f241aaa5d",
            "state": "State01",
            "redirect_uri": "nana://authentication",
            "code_challenge": codeChallenge,
            "code_challenge_method": "plain"
        ]
        
        AF.request("https://myanimelist.net/v1/oauth2/authorize?", method: .get, parameters: parameters).response { AFDATA in
            
        }
    }
    
    
}
