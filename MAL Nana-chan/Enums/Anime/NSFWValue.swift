//
//  NSFWValue.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum NSFWValue: String, APIEnum {
    case white
    case gray
    case black

    static let unknownValue = NSFWValue.white
}
