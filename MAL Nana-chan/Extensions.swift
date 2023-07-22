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

