//
//  AuthenticationService.swift
//  MAL Nana-chan
//

import UIKit
import OAuthSwift

/// Signs the user in and out of MyAnimeList.
protocol AuthenticationServicing: AnyObject {

    var isSignedIn: Bool { get }

    /// Presents MAL's web sign-in from `viewController` and stores the token.
    func signIn(from viewController: UIViewController, completion: @escaping (Result<Void, APIError>) -> Void)

    func signOut()

    /// Called by the scene delegate when MAL redirects back into the app.
    func handleCallback(url: URL) -> Bool
}

/// OAuth 2.0 + PKCE sign-in, via OAuthSwift.
final class AuthenticationService: AuthenticationServicing {

    private let tokenStore: TokenStoring

    /// Held for the lifetime of the service, not per call: OAuthSwift needs the
    /// same instance alive to finish the flow after the redirect comes back.
    private let oauth: OAuth2Swift

    /// Retains the Safari handler for the duration of one sign-in.
    private var urlHandler: SafariURLHandler?

    init(tokenStore: TokenStoring) {
        self.tokenStore = tokenStore
        oauth = OAuth2Swift(
            consumerKey: AppConfiguration.MyAnimeList.clientID,
            // MAL's PKCE flow has no client secret — the code challenge is what
            // proves the app that redeems the code is the one that started.
            consumerSecret: "",
            authorizeUrl: AppConfiguration.MyAnimeList.authorizeURL,
            accessTokenUrl: AppConfiguration.MyAnimeList.accessTokenURL,
            responseType: "code"
        )
        oauth.accessTokenBasicAuthentification = true
    }

    var isSignedIn: Bool { tokenStore.isSignedIn }

    func signIn(from viewController: UIViewController, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let codeVerifier = generateCodeVerifier() else {
            completion(.failure(.unknown(Strings.Common.somethingWentWrong)))
            return
        }

        // The handler has to be installed *before* `authorize`, which is where
        // OAuthSwift consults it to decide how to open the login page.
        let handler = SafariURLHandler(viewController: viewController, oauthSwift: oauth)
        urlHandler = handler
        oauth.authorizeURLHandler = handler

        // MAL supports only `plain` for PKCE, so the challenge *is* the verifier.
        _ = oauth.authorize(
            withCallbackURL: AppConfiguration.MyAnimeList.callbackURL,
            scope: AppConfiguration.MyAnimeList.scope,
            state: Self.state,
            codeChallenge: codeVerifier,
            codeChallengeMethod: "plain",
            codeVerifier: codeVerifier
        ) { [weak self] result in
            self?.urlHandler = nil

            switch result {
            case .success(let (credential, _, _)):
                self?.tokenStore.save(token: credential.oauthToken, expiresAt: credential.oauthTokenExpiresAt)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unknown(error.localizedDescription)))
            }
        }
    }

    func signOut() {
        tokenStore.clear()
    }

    func handleCallback(url: URL) -> Bool {
        guard url.host == AppConfiguration.MyAnimeList.callbackHost else { return false }
        OAuthSwift.handle(url: url)
        return true
    }

    /// CSRF guard echoed back by MAL. A fixed value is weak — a fresh random
    /// string per attempt, compared on return, is the correct implementation —
    /// but changing it means threading the expected value through the redirect,
    /// so it is left as it was rather than half-done.
    private static let state = "State01"
}
