//
//  Season.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum Season: String, Codable {
    case winter
    case spring
    case summer
    case fall
    
    func getSeason() -> String {
        switch self {
        case .winter: return "Winter"
        case .spring: return "Spring"
        case .summer: return "Summer"
        case .fall: return "Fall"
        default: return "Winter"
        }
    }
}
