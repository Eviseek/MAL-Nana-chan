//
//  ViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit
import OAuthSwift

class MainScreen: UIViewController {
    
    private var viewModel: MainScreenViewModel? = nil
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainScreenViewModel(viewController: self)
        
        let nib = UINib(nibName: Identifiers.ItemSectionTableViewCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Identifiers.ItemSectionTableViewCell.rawValue)
        tableView.dataSource = self
    }
    
}


extension MainScreen: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ItemSectionTableViewCell.rawValue) as? ItemSectionTableViewCell {
            cell.parentVC = self
            cell.itemSectionNameLabel.text = viewModel?.sections[indexPath.row].name
            cell.fillCollectionView(items: viewModel?.sections[indexPath.row].items ?? [Item]())
            return cell
        }
        return UITableViewCell()
    }
    
}

