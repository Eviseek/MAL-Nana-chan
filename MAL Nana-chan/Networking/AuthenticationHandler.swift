//
//  AuthenticationHandler.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation
import Alamofire
import OAuthSwift

/*
 token
 eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjA4NDUyOTRhM2NlZWMwZGMyNmMwODdhNGRhZmIwZjBiMzRlZmNiOTYwYWJhZDM0M2U1MjI0YTEwNjIyN2IwNjBlYjc2NzMzMzliODcwOTk3In0.eyJhdWQiOiJmNDZkNDc0NDk0OTBkNzcyZmYwMWEzMWYyNDFhYWE1ZCIsImp0aSI6IjA4NDUyOTRhM2NlZWMwZGMyNmMwODdhNGRhZmIwZjBiMzRlZmNiOTYwYWJhZDM0M2U1MjI0YTEwNjIyN2IwNjBlYjc2NzMzMzliODcwOTk3IiwiaWF0IjoxNjc1NTI4MDY3LCJuYmYiOjE2NzU1MjgwNjcsImV4cCI6MTY3Nzk0NzI2Nywic3ViIjoiMTE4NzU4NzEiLCJzY29wZXMiOltdfQ.g-96d8i_2nXqxsxBRJnw5TZ0GkzAjBKxOBQjtNXh1IEVerKDmC70sWZ2W8Dniq65MVPlEqwqZ0p_A-iOafyGN1dxOOkzQVatW-PrOphAMgqNx4CIQQ9wBuhJM17YcLZTwrvkZc4yVJaJ0duI-Ng7aYSKrBGvLzwy6Hr3oNke-P3D1kAe5lhs2BEikNbgEXz1fhmymQJETzPIJdUet_G4c2ivmj1loevsqxn1omxnGNYfFInZLQCHpWgtfSOsQuTumRVteiTEmIJKmkJtm7SXkQ-XaW59o8RrxDubklPslG3aZWbsme4GgKncaQydj8dDBTs20uHTNIeTdgod7-6ILg
 */

struct AuthenticationHandler {
    
    private let oauthswift = OAuth2Swift(
        consumerKey: "f46d47449490d772ff01a31f241aaa5d",
        consumerSecret: "",
        authorizeUrl: "https://myanimelist.net/v1/oauth2/authorize?",
        accessTokenUrl: "https://myanimelist.net/v1/oauth2/token",
        responseType: "code"
    )
    
    private func makeOAuthRequest() {
        
        oauthswift.accessTokenBasicAuthentification = true

        guard let codeVerifier = generateCodeVerifier() else {return}
        let codeChallenge = codeVerifier

        _ = oauthswift.authorize(
            withCallbackURL: "nana://authentication",
            scope: "requestedScope",
            state:"State01",
            codeChallenge: codeChallenge,
            codeChallengeMethod: "plain",
            codeVerifier: codeVerifier) { result in
            switch result {
            case .success(let (credential, response, parameters)):
            debugPrint(response)
                print("token")
              print(credential.oauthToken)
              // Do your request
            case .failure(let error):
                debugPrint(error)
              print(error.localizedDescription)
            }
        }
    }
    
    func authenticate(_ viewController: UIViewController) {
        makeOAuthRequest()
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthswift)
    }
    
}
