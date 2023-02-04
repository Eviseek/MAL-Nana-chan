//
//  ViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit
import OAuthSwift

class MainScreen: UIViewController {
    
    var sections: [Section] = []
    
    let handler = AuthenticationHandler()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataDownloader().get("https://api.myanimelist.net/v2/anime/1") { (response: Anime?) in
            print(response?.title)
        }
        
        loadSections()
        
        let nib = UINib(nibName: Identifiers.ItemSectionTableViewCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Identifiers.ItemSectionTableViewCell.rawValue)
        tableView.dataSource = self
        
    }
    
    func loadSections() {
        let section = Section(name: "First Section", items: [Item(title: "Item1"), Item(title: "Item2"), Item(title: "Item3")])
        let section2 = Section(name: "Second Section", items: [Item(title: "Item1"), Item(title: "Item2"), Item(title: "Item3"), Item(title: "Item1"), Item(title: "Item2"), Item(title: "Item3")])
        sections.append(section)
        sections.append(section2)
    }

}


extension MainScreen: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ItemSectionTableViewCell.rawValue) as? ItemSectionTableViewCell {
            cell.itemSectionNameLabel.text = sections[indexPath.row].name
            cell.fillCollectionView(items: sections[indexPath.row].items)
            return cell
        }
        return UITableViewCell()
    }
    
}

