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
    
    func fetch<T>(_ url: String, completion: @escaping (T?) -> Void) where T: Codable {
        
        AF.request(url, headers: unauthenticatedHeaders).responseDecodable(of: T.self, completionHandler: { response in
            debugPrint(response)
            completion(response.value)
        })
    }
    
    private func decode() {
        
    }
    
    
    
}
