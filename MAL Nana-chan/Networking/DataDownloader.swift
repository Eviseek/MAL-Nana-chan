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
        
        if let token = TokenHandler.handler.getToken() {
            print("auth header")
            headers.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
            headers.add(name: "Authorization", value: "Bearer " + token)
        } else {
            print("not auth header")
            headers.add(name: Identifiers.headerAuthID.rawValue, value: "f46d47449490d772ff01a31f241aaa5d")
        }
        
        return headers
    }
    
    
    func fetchData<T>(_ url: String, completion: @escaping (T?) -> Void) where T: Codable {
        
        if (url.contains("myanimelist")) {
            
            let enc = URLEncoding(arrayEncoding: .noBrackets)
            
            AF.request(url, encoding: enc, headers: getHeader()).responseDecodable(of: T.self, completionHandler: { response in
               
               // debugPrint(response)
                completion(response.value)
            })
            
        } else {
            
            AF.request(url).responseDecodable(of: T.self, completionHandler: { response in
             //   debugPrint(response)
                completion(response.value)
            })
            
        }
    }
    
    func changeList(_ url: String, params: MyListStatus, completion: @escaping () -> Void) {
        
//        var listHeaders: HTTPHeaders = []
//        listHeaders.add(name: "status", value: params.status.rawValue)
//        listHeaders.add(name: "score", value: params.score.description)
//        if let episodesCount = params.episodesWatchedCount {
//            listHeaders.add(name: "num_watched_episodes", value: episodesCount.description)
//        }
//        if let token = TokenHandler.handler.getToken() {
//            listHeaders.add(name: "Authorization", value: "Bearer " + token)
//        }
//
//        print("my headers look: \(listHeaders)")
        
        var parameters = [
            "status": params.status.rawValue,
            "score" : "0"
        ]
        
        print("parameters \(parameters)")
        
        AF.request(url, method: .put, parameters: parameters, headers: getHeader()).response { AFdata in
            debugPrint(AFdata)
            completion()
        }
            
    }

    
    private func decode() {
        
    }
    
    
    
}
