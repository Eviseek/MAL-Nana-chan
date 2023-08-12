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
    
    
    func fetchData<T>(_ url: String, completion: @escaping (T?, AFError?) -> Void) where T: Codable {
        
        if (url.contains("myanimelist")) {
            
            let enc = URLEncoding(arrayEncoding: .noBrackets)
            
            AF.request(url, encoding: enc, headers: getHeader()).responseDecodable(of: T.self, completionHandler: { response in
               
              // debugPrint(response)
                completion(response.value, response.error)
            })
            
        } else {
            
            AF.request(url).responseDecodable(of: T.self, completionHandler: { response in
              //  debugPrint(response)
                completion(response.value, response.error)
            })
            
        }
    }
    
    func changeAnimeList(_ url: String, params: MyAnimeListStatus, completion: @escaping () -> Void) {
        
        let parameters = [
            "status": params.status.rawValue,
            "score" : params.score,
            "num_watched_episodes": params.episodesWatchedCount!,
            "priority": params.priority?.rawValue ?? 0
        ] as [String : Any]
        
        print("parameters \(parameters)")
        
        AF.request(url, method: .put, parameters: parameters, headers: getHeader()).response { AFdata in
            debugPrint(AFdata)
            completion()
        }
            
    }
    
    func changeMangaList(_ url: String, params: MyMangaListStatus, completion: @escaping () -> Void) {
        
        let parameters = [
            "status": params.status.rawValue,
            "score" : params.score,
            "num_chapters_read": params.chaptersReadCount!,
            "num_volumes_read": params.volumesReadCount!,
            "priority": params.priority?.rawValue ?? 0
        ] as [String : Any]
        
        print("parameters \(parameters)")
        
        AF.request(url, method: .put, parameters: parameters, headers: getHeader()).response { AFdata in
            debugPrint(AFdata)
            completion()
        }
            
    }
    
    func deleteList(_ url: String, completion: @escaping () -> Void) {
        
        AF.request(url, method: .delete, headers: getHeader()).response { response in
            debugPrint(response)
            print("response desc \(response.description)")
            print("response data \(response.data)")
            completion()
        }
            
    }
    
    
    
}
