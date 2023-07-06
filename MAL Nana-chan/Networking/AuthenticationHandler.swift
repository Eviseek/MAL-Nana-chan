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
 eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImFiY2RhN2U4MTZiN2VmOTAxMTIxNjFkNGZkNjRjNGYwNDU3YmIxMjFlM2YyOWU0YTg2OTdhODM2ODg5YTZkMTY0YmQ5OWVhZWU3MTlmN2ExIn0.eyJhdWQiOiJmNDZkNDc0NDk0OTBkNzcyZmYwMWEzMWYyNDFhYWE1ZCIsImp0aSI6ImFiY2RhN2U4MTZiN2VmOTAxMTIxNjFkNGZkNjRjNGYwNDU3YmIxMjFlM2YyOWU0YTg2OTdhODM2ODg5YTZkMTY0YmQ5OWVhZWU3MTlmN2ExIiwiaWF0IjoxNjg4Njc0MzQyLCJuYmYiOjE2ODg2NzQzNDIsImV4cCI6MTY5MTM1Mjc0Miwic3ViIjoiMTE4NzU4NzEiLCJzY29wZXMiOltdfQ.hnwiTAiJRzP0mrAlr89l8mxS7bDZ3yDbrdycgdMMkgdX1slxo7zLjDnc6H9DxXgOeV3Zn2VFOAntax9fn-p_8J-Q_Rl7cX5McMzSiw41qVWr8rWuY9CymZu6NgmZAFna7BN8PM1b8X4hOqML9H5KzooS3eSPaZiC8nIChGeSbdwHJ7FAAGWN2i6ct9C9wEQClHWr1kpZ8bEXIGKEBgUEItkQIKzpEjEyJ4MpkaN2dyHWgLRG9iIA1wZZZIySte7icoVmtwFmnjawy0HpZN_6xZponErSm3xGA47xninGyHgR5YaExk54runoLUBHA8tOfagLQQq7u4SdK1uuK3-biw
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
                TokenHandler.handler.saveToken(credential.oauthToken)
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
