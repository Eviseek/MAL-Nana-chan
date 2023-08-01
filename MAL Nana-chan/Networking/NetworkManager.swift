//
//  NetworkManager.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 01.08.2023.
//

import Foundation
import Alamofire

protocol NetworkManagerDelegate {
    func connectionRestored()
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    var reachabilityDelegate: NetworkManagerDelegate?
    
    private var lastStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    
    func startNetworkReachabilityObserver() {
        
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                print("not reachable")
                self.lastStatus = .notReachable
            case .reachable(.cellular):
                print("cellular")
                if self.lastStatus == .notReachable {
                    self.reachabilityDelegate?.connectionRestored()
                }
                self.lastStatus = .reachable(.cellular)
            case .reachable(.ethernetOrWiFi):
                print("wifi or ethernet")
                if self.lastStatus == .notReachable {
                    self.reachabilityDelegate?.connectionRestored()
                }
                self.lastStatus = .reachable(.ethernetOrWiFi)
            default:
                self.lastStatus = .unknown
                print("unknown")
            }
        }
        
    }
    
}
