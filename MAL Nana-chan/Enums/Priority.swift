//
//  Priority.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 05.08.2023.
//

import Foundation

enum Priority: Int, Codable {
    case low = 0
    case medium = 1
    case high = 2
    
    func getPriorityString() -> String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    func getPriorityInt() -> Int {
        switch self {
        case .low: return Priority.low.rawValue
        case .medium: return Priority.medium.rawValue
        case .high: return Priority.high.rawValue
        }
    }
    
}

class PriorityManager {
    
    func getPriorityList() -> [String] {
        return ["Low", "Medium", "High"]
    }
    
}
