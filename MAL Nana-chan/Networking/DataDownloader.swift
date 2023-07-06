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
            headers.add(name: "Authorization", value: "Bearer " + token)
        } else {
            print("not auth header")
            headers.add(name: Identifiers.headerAuthID.rawValue, value: "f46d47449490d772ff01a31f241aaa5d")
        }
        
        return headers
    }
    
    
    func fetchData<T>(_ url: String, completion: @escaping (T?) -> Void) where T: Codable {
        
        if (url.contains("myanimelist")) {
            
            AF.request(url, headers: getHeader()).responseDecodable(of: T.self, completionHandler: { response in
               
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
