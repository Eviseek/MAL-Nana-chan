//
//  MyInterceptor.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 01.08.2023.
//

import Foundation
import Alamofire

class MyInterceptor {
    
  //  let accessToken: String
    
    init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
       // urlRequest.headers.add(.authorization(bearerToken: accessToken))
        
        completion(.success(urlRequest))
    }
    
}
