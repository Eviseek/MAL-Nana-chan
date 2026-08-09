//
//  APIClient.swift
//  MAL Nana-chan
//

import Foundation
import Alamofire

/// Sends `Endpoint`s and decodes the answers.
protocol APIClienting: AnyObject {

    /// Performs a request and decodes the body.
    ///
    /// `Value` is `Sendable` as well as `Decodable` because the decoded value — and
    /// its metatype, passed as `type` — cross from Alamofire's queue back to the
    /// caller.
    func fetch<Value: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as type: Value.Type,
        completion: @escaping (Result<Value, APIError>) -> Void
    )

    /// Performs a request whose body we don't care about (PATCH/DELETE).
    func send(_ endpoint: Endpoint, completion: @escaping (Result<Void, APIError>) -> Void)
}

/// Alamofire-backed `APIClienting`.
final class APIClient: APIClienting {

    private let session: Session
    private let tokenStore: TokenStoring

    init(session: Session = .default, tokenStore: TokenStoring) {
        self.session = session
        self.tokenStore = tokenStore
    }

    func fetch<Value: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as type: Value.Type,
        completion: @escaping (Result<Value, APIError>) -> Void
    ) {
        request(for: endpoint)
            .validate()
            .responseDecodable(of: Value.self, decoder: Self.decoder) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(.from(error)))
                }
            }
    }

    func send(_ endpoint: Endpoint, completion: @escaping (Result<Void, APIError>) -> Void) {
        request(for: endpoint)
            .validate()
            .response { response in
                if let error = response.error {
                    completion(.failure(.from(error)))
                } else {
                    completion(.success(()))
                }
            }
    }

    // MARK: - Request building

    private static let decoder = JSONDecoder()

    private func request(for endpoint: Endpoint) -> DataRequest {
        // `.validate()` at the call sites above matters more than it looks.
        // Without it a 401 still carries a JSON error body, Alamofire decodes it
        // as the expected model, and the failure surfaces as "the data couldn't
        // be read because it isn't in the correct format" — pointing at the
        // models instead of at auth.
        guard !endpoint.formBody.isEmpty else {
            return session.request(
                endpoint.url,
                method: HTTPMethod(rawValue: endpoint.method.rawValue),
                headers: headers(for: endpoint.authorization)
            )
        }

        // `URLEncoding.httpBody` is stated explicitly rather than relying on
        // `URLEncoding.default`, whose `.methodDependent` behaviour would put
        // these parameters in the query string for some methods.
        return session.request(
            endpoint.url,
            method: HTTPMethod(rawValue: endpoint.method.rawValue),
            parameters: endpoint.formBody,
            encoding: URLEncoding.httpBody,
            headers: headers(for: endpoint.authorization)
        )
    }

    private func headers(for authorization: Endpoint.Authorization) -> HTTPHeaders {
        // No `Content-Type` here on purpose: it describes the request *body*,
        // and Alamofire sets it itself from the encoding on the calls that send
        // one.
        switch authorization {
        case .none:
            return []
        case .clientID:
            return [Self.clientIDHeader: AppConfiguration.MyAnimeList.clientID]
        case .userToken:
            // Falling back to the client id keeps public reads working when the
            // user is signed out, instead of failing the request outright.
            guard let token = tokenStore.accessToken else {
                return [Self.clientIDHeader: AppConfiguration.MyAnimeList.clientID]
            }
            return [.authorization(bearerToken: token)]
        }
    }

    private static let clientIDHeader = "X-MAL-CLIENT-ID"
}
