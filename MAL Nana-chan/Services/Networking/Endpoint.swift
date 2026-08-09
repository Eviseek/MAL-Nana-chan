//
//  Endpoint.swift
//  MAL Nana-chan
//

import Foundation

/// One request, described as data.
struct Endpoint {

    enum Method: String {
        case get = "GET"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    /// Which credential the request carries.
    enum Authorization {
        /// The app's public client id — enough for public MAL reads.
        case clientID
        /// The signed-in user's bearer token. Required for anything under
        /// `/users/@me` or `my_list_status`.
        case userToken
        /// Jikan needs no credentials at all, and sending MAL's header to it
        /// would be leaking a credential to a third party.
        case none
    }

    let url: String
    var method: Method = .get
    var authorization: Authorization = .clientID

    /// Form-encoded request body. MAL documents `my_list_status` updates as
    /// `PATCH` with `application/x-www-form-urlencoded`.
    var formBody: [String: String] = [:]
}

extension Endpoint {

    /// Builds an endpoint from a base URL, a path and ordered query items.
    ///
    /// Query items are an array of pairs rather than a dictionary so the
    /// resulting URL is deterministic — helpful when reading logs, and required
    /// if a response is ever cached by URL.
    static func make(
        baseURL: String,
        path: String,
        query: [(name: String, value: String)] = [],
        method: Method = .get,
        authorization: Authorization = .clientID,
        formBody: [String: String] = [:]
    ) -> Endpoint {
        var url = baseURL + path
        if !query.isEmpty {
            url += "?" + QueryEncoding.string(from: query)
        }
        return Endpoint(url: url, method: method, authorization: authorization, formBody: formBody)
    }

    /// Wraps a URL the API handed us — paging `next`/`previous` links come back
    /// fully formed and already encoded, so they must not be rebuilt.
    static func absolute(_ url: String, authorization: Authorization) -> Endpoint {
        Endpoint(url: url, authorization: authorization)
    }
}

/// Percent-encoding for query values.
enum QueryEncoding {

    /// Everything legal in a query string *except* the sub-delimiters that would
    /// end a value early.
    ///
    /// `CharacterSet.urlQueryAllowed` deliberately permits `&`, `+`, `=`, `?`
    /// and `#`, because they are legal *somewhere* in a query. Inside a single
    /// value they are not: searching for "Yes & No" with the default set sends
    /// `q=Yes%20&%20No&fields=…`, where the bare `&` closes `q` and the rest of
    /// the title is parsed as another parameter. `+` is subtler still — it
    /// survives encoding and the server reads it back as a space.
    static let allowed: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "&+=?#")
        return allowed
    }()

    static func encode(_ value: String) -> String {
        value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
    }

    static func string(from items: [(name: String, value: String)]) -> String {
        items
            .map { "\(encode($0.name))=\(encode($0.value))" }
            .joined(separator: "&")
    }
}
