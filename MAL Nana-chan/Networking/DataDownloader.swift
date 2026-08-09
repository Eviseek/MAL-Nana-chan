//
//  DataDownloader.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation
import Alamofire

struct DataDownloader {
    
    static let dataDownloader = DataDownloader()
    
    //function to set up either authenticated header or unautheticated
    private func getHeader() -> HTTPHeaders {

        var headers: HTTPHeaders = []

        // No Content-Type here on purpose. It describes the *request body*, and
        // GETs don't have one. Alamofire sets it itself from the ParameterEncoding
        // on the calls that do send a body (the my_list_status updates below).
        if let token = TokenHandler.handler.getToken() {
            headers.add(name: "Authorization", value: "Bearer " + token)
        } else {
            headers.add(name: Identifiers.headerAuthID.rawValue, value: "f46d47449490d772ff01a31f241aaa5d")
        }

        return headers
    }
    
    
    func fetchData<T>(_ url: String, completion: @escaping (T?, AFError?) -> Void) where T: Codable {
        
        // `.validate()` matters more than it looks. Without it a 401 (expired
        // token) still carries a JSON error body, Alamofire happily tries to
        // decode it as T, and the failure surfaces as "the data couldn't be read
        // because it isn't in the correct format" — which points at the models
        // instead of at auth. With it you get an explicit unacceptableStatusCode.
        if (url.contains("myanimelist")) {

            let enc = URLEncoding(arrayEncoding: .noBrackets)

            AF.request(url, encoding: enc, headers: getHeader())
                .validate()
                .responseDecodable(of: T.self, completionHandler: { response in
                    completion(response.value, response.error)
                })

        } else {

            AF.request(url)
                .validate()
                .responseDecodable(of: T.self, completionHandler: { response in
                    completion(response.value, response.error)
                })

        }
    }
    
    // MAL documents my_list_status updates as PATCH with an
    // application/x-www-form-urlencoded body. URLEncoding.httpBody is stated
    // explicitly rather than relying on URLEncoding.default's .methodDependent
    // behaviour, so the parameters can't silently end up in the query string.
    func changeAnimeList(_ url: String, params: MyAnimeListStatus, completion: @escaping (AFError?) -> Void) {

        var parameters: [String: Any] = [
            "status": params.status.rawValue,
            "score": params.score
        ]
        // Only send what we actually have. PATCH is a partial update, so an
        // omitted field keeps its current server-side value — whereas the old
        // force-unwrap crashed whenever the count was nil.
        if let episodesWatched = params.episodesWatchedCount {
            parameters["num_watched_episodes"] = episodesWatched
        }
        if let priority = params.priority {
            parameters["priority"] = priority.rawValue
        }

        AF.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.httpBody, headers: getHeader())
            .validate()
            .response { response in
                completion(response.error)
            }

    }

    func changeMangaList(_ url: String, params: MyMangaListStatus, completion: @escaping (AFError?) -> Void) {

        var parameters: [String: Any] = [
            "status": params.status.rawValue,
            "score": params.score
        ]
        if let chaptersRead = params.chaptersReadCount {
            parameters["num_chapters_read"] = chaptersRead
        }
        if let volumesRead = params.volumesReadCount {
            parameters["num_volumes_read"] = volumesRead
        }
        if let priority = params.priority {
            parameters["priority"] = priority.rawValue
        }

        AF.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.httpBody, headers: getHeader())
            .validate()
            .response { response in
                completion(response.error)
            }

    }

    func deleteList(_ url: String, completion: @escaping (AFError?) -> Void) {

        AF.request(url, method: .delete, headers: getHeader())
            .validate()
            .response { response in
                completion(response.error)
            }

    }
    
    
    
}
