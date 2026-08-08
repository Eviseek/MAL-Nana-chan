//
//  SkeletonManager.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 12.08.2023.
//

import Foundation
import UIKit
import SkeletonView

struct SkeletonManager {
    
    func showSkeletonFor(_ view: UIView, firstColor: UIColor = .silver, secondColor: UIColor = .asbestos, animation: SkeletonLayerAnimation? = nil) {
        let gradient = SkeletonGradient(baseColor: firstColor, secondaryColor: secondColor)
        view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }
    
    func hideSkeletonFor(_ view: UIView, transition: SkeletonTransitionStyle? = nil) {
        if let transition = transition {
            view.hideSkeleton(transition: transition)
        } else {
            view.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
}
