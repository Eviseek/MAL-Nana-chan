//
//  Season.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum Season: String, Codable {
    case winter// = "Winter"
    case spring //= "Spring"
    case summer //= "Summer"
    case fall //= "Fall"
    
    func stringValue() -> String {
        switch self {
        case .winter: return "Winter"
        case .spring: return "Spring"
        case .summer: return "Summer"
        case .fall: return "Fall"
        }
    }
}

struct SeasonManager {
    
    func getSeasonForMonth(_ month: Int) -> Season {
        switch month {
        case 1, 2, 3: return Season.winter
        case 4, 5, 6: return Season.spring
        case 7, 8, 9: return Season.summer
        case 10, 11, 12: return Season.fall
        default: return Season.winter
        }
    }
    
    
    func getThisSeason() -> Season {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        let season = getSeasonForMonth(month)
        
        return season
    }
    
    func getUpcomingSeason() -> (Season, Bool) {
        let thisSeason = getThisSeason()
        print("THIS SEASON is: " ,thisSeason)
        
        switch thisSeason {
        case .winter: return (.spring, false)
        case .spring: return (.summer, false)
        case .summer: return (.fall, false)
        case .fall: return (.winter, true)
        }
    }
}
