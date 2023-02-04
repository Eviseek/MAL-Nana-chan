//
//  DataDownloader.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation
import Alamofire

struct DataDownloader {
    
    let unauthenticatedHeaders: HTTPHeaders = [
        "X-MAL-CLIENT-ID": "f46d47449490d772ff01a31f241aaa5d"
    ]
    
    let authenticatedHeaders: HTTPHeaders = [
    ]
    
    func get<T>(_ url: String, completion: @escaping (T?) -> Void) where T: Codable {
        
        let url = "https://api.myanimelist.net/v2/anime/1"
        
        AF.request(url, headers: unauthenticatedHeaders).responseDecodable(of: T.self, completionHandler: { response in
            debugPrint(response)
            completion(response.value)
        })
    }
    
    private func decode() {
        
    }
    
    
    
}
