//
//  Extensions.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 23.03.2023.
//

import Foundation
import UIKit

extension String {
    
    func extractSeason() -> String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        guard date != nil else { return "Unknown season"}
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date!)
        
        if let month = components.month, let year = components.year {
            var season = SeasonManager().getSeasonForMonth(month)
            let seasonStr = "\(season.stringValue()) \(year)"
            return seasonStr
        }
      
        return "Unknown season"
    }
}

