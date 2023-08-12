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
        let dateFormatter = DateFormatManager.shared.dateFormatter
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
    
    func convertToReadableDateString(originalFormat: String, newFormat: String = "dd MMM yyyy") -> String {
        let dateFormatter = DateFormatManager.shared.dateFormatter
        dateFormatter.dateFormat = originalFormat
        let date = dateFormatter.date(from: self)
        
        let secondDayFormatter = DateFormatter()
        secondDayFormatter.dateFormat = newFormat

        if let date = date {
            return secondDayFormatter.string(from: date)
        } else {
            return "Not specified."
        }
    }
    
    func convertToDate(finalFormat: String = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ") -> Date? {
        let formatter = DateFormatManager.shared.dateFormatter
        formatter.dateFormat = finalFormat
        return formatter.date(from: self)
    }
}

extension Date {
    
    func convertToString(originalFormat: String) -> String {
        let formatter = DateFormatManager.shared.dateFormatter
        formatter.dateFormat = originalFormat
        return formatter.string(from: self)
    }
    
}

extension UIViewController {
    
    func showToast(message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 10
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func showErrorDialog(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            switch action.style {
                case .default: self.dismiss(animated: true)
                case .destructive: self.dismiss(animated: true)
                case .cancel: self.dismiss(animated: true)
            }
        }))
        self.present(alert, animated: true)
    }
    
}

