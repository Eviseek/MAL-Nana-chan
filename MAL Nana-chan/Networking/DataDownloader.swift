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
    
    let unauthenticatedHeaders: HTTPHeaders = [
        "X-MAL-CLIENT-ID": "f46d47449490d772ff01a31f241aaa5d"
    ]
    
    let authenticatedHeaders: HTTPHeaders = [
    ]
    
    func fetchData<T>(_ url: String, completion: @escaping (T?) -> Void) where T: Codable {
        
        if (url.contains("myanimelist")) {
            
            AF.request(url, headers: unauthenticatedHeaders).responseDecodable(of: T.self, completionHandler: { response in
               
                debugPrint(response)
                completion(response.value)
            })
            
        } else {
            
            AF.request(url).responseDecodable(of: T.self, completionHandler: { response in
             //   debugPrint(response)
                completion(response.value)
            })
            
        }
    }

    
    private func decode() {
        
    }
    
    
    
}
