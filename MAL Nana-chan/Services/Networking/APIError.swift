//
//  APIError.swift
//  MAL Nana-chan
//

import Foundation
import Alamofire

/// Everything that can go wrong on the way to or back from an API.
enum APIError: Error {

    /// No usable network connection.
    case notConnected
    /// HTTP 401/403 — the stored token is missing, expired or rejected.
    case unauthorized
    /// The request succeeded but the body didn't match the model.
    case decoding(String)
    /// Any other non-2xx response.
    case server(statusCode: Int)
    /// The endpoint produced a string that isn't a valid URL.
    case invalidURL
    case unknown(String)

    /// Copy that is safe to put in front of the user.
    var userMessage: String {
        switch self {
        case .notConnected:
            return Strings.Network.offline
        case .unauthorized:
            return Strings.Network.unauthorized
        case .decoding, .invalidURL:
            return Strings.Common.somethingWentWrong
        case .server(let statusCode):
            return "The server responded with an error (\(statusCode))."
        case .unknown(let description):
            return description
        }
    }
}

extension APIError {

    /// Translates Alamofire's failure into ours.
    ///
    /// `AFError` nests the interesting part several layers down, so this is the
    /// one place in the app that has to know its shape.
    static func from(_ error: AFError) -> APIError {
        if let urlError = error.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed, .timedOut:
                return .notConnected
            default:
                break
            }
        }

        if case .responseValidationFailed(let reason) = error,
           case .unacceptableStatusCode(let code) = reason {
            return code == 401 || code == 403 ? .unauthorized : .server(statusCode: code)
        }

        if case .responseSerializationFailed(let reason) = error {
            return .decoding(String(describing: reason))
        }

        if case .invalidURL = error {
            return .invalidURL
        }

        return .unknown(error.localizedDescription)
    }
}
