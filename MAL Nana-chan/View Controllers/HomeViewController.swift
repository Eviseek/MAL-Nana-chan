//
//  ViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit
import OAuthSwift
import NVActivityIndicatorView

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel(viewController: self)
        tableViewSetUp()
      
    }
    
    private func tableViewSetUp() {
        let nib = UINib(nibName: Identifiers.ItemSectionTableViewCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Identifiers.ItemSectionTableViewCell.rawValue)
        
        let ytNib = UINib(nibName: Identifiers.YTEmbedTableViewCell.rawValue, bundle: nil)
        tableView.register(ytNib, forCellReuseIdentifier: Identifiers.YTEmbedTableViewCell.rawValue)
        
        tableView.dataSource = self
    }
    
}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.contentSize ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (viewModel!.hasPromo) {
            if (indexPath.row == 0) {
                if let ytCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.YTEmbedTableViewCell.rawValue) as? YoutubeEmbedTableViewCell {
                    print("Youtube ID", viewModel!.promoId)
                    ytCell.setUpPlayer(with: viewModel!.promoId ?? "")
                    return ytCell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ItemSectionTableViewCell.rawValue) as? ItemSectionTableViewCell {
                    var alternativePath = indexPath.row - 1
                    cell.parentVC = self
                    cell.itemSectionNameLabel.text = viewModel?.sections[alternativePath].name
                    cell.fillCollectionView(section: viewModel?.sections[alternativePath] ?? Section())
                    return cell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ItemSectionTableViewCell.rawValue) as? ItemSectionTableViewCell {
                cell.parentVC = self
                cell.itemSectionNameLabel.text = viewModel?.sections[indexPath.row].name
                cell.fillCollectionView(section: viewModel?.sections[indexPath.row] ?? Section())
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}

