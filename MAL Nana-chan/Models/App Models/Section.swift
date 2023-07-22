//
//  Section.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

struct Section<T: Codable> {
    var name: String = "Unnamed Section"
    var type: ItemType = .anime
    var response: Response<T>
//    var items: [Item] = [Item]()
//    var type: ItemType = .anime
//    var paging: Paging? 
}
