//
//  ActivityIndicator.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 27.03.2023.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ActivityIndicator {
    
    public static let indicator = ActivityIndicator()
    
    private var activityIndicator: NVActivityIndicatorView
    private var parentFrame = UIView()
    
    init() {
        let frame = CGRect()
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .lineScalePulseOut, color: UIColor(named: "mal_color"))
    }
    
    func startAnimating(view: UIView, bg: UIColor? = nil) {
        parentFrame = UIView()
        if let bg = bg {
            parentFrame.backgroundColor = bg
        } else {
            parentFrame.backgroundColor = view.backgroundColor
        }
        parentFrame.frame = view.bounds
        view.addSubview(parentFrame)
      
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let indicatorFrame = CGRect(x: (screenWidth - 50) / 2, y: (screenHeight - 50) / 2, width: 50, height: 50)
//
//
//        let activityIndicator = NVActivityIndicatorView(frame: frame, type: .lineScalePulseOut, color: UIColor(named: "mal_color"))
        activityIndicator.frame = indicatorFrame
        parentFrame.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in //delaying for one second
            self.parentFrame.removeFromSuperview()
          }
    }
    
}
