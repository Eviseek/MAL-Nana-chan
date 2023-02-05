//
//  MainScreenViewModel.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit

class MainScreenViewModel {
    
    var viewController: MainScreen
    let dataDownloader = DataDownloader()
    
    var sections = [Section]()
    
    
    
    init(viewController: MainScreen) {
        self.viewController = viewController
        viewDidLoad()
    }
    
    private func viewDidLoad() {
        getData {
            self.viewController.tableView.reloadData()
        }
    }
    
    
    private func getData(completion: @escaping () -> ()) {
        dataDownloader.fetch("https://api.myanimelist.net/v2/anime/season/2020/spring?fields=mean") { (response: Response?) in
            if let data = response?.data {
                self.createSection(sectionName: "Spring 2020 anime", data: data)
                print(data)
                completion()
            }
        }
    }
    
    private func createSection(sectionName: String?, data: [Node]) {
        
        var items = [Item]()
        
        for data in data {
            items.append(Item(title: data.node.title, image: data.node.main_picture?.medium ?? nil, score: data.node.mean ?? nil))
        }
        
        var section = Section(items: items)
        
        if let sectionName = sectionName {
            section.name = sectionName
        }
        
        sections.append(section)
    }
    
    
}
