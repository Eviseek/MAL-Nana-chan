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
    
    private var viewModel = HomeViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorMsgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Authentication().authenticate()
        
       //TODO: testing code ----- TokenHandler.handler.deleteToken() --------
        
        viewModel.viewDidLoad(vc: self)
        tableViewSetUp()
      
    }
    
    private func tableViewSetUp() {
        let nib = UINib(nibName: Identifiers.animeSectionTVCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Identifiers.animeSectionTVCell.rawValue)
        
        let ytNib = UINib(nibName: Identifiers.YTEmbedTableViewCell.rawValue, bundle: nil)
        tableView.register(ytNib, forCellReuseIdentifier: Identifiers.YTEmbedTableViewCell.rawValue)
        
        tableView.dataSource = self
    }
    
    func setUpErrorView(message: String) {
        errorMsgLabel.text = message
        tableView.isHidden = true
    }
    
    func reloadData() {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    @IBAction func fetchDataAgainClicked(_ sender: UIButton) {
        viewModel.fetchDataAgainClicked()
    }
}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contentSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (viewModel.hasPromo) {
            if (indexPath.row == 0) {
                if let ytCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.YTEmbedTableViewCell.rawValue) as? YoutubeEmbedTableViewCell {
                    print("Youtube ID", viewModel.promoId)
                    ytCell.setUpPlayer(with: viewModel.promoId ?? "")
                    return ytCell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.animeSectionTVCell.rawValue) as? AnimeSectionTableViewCell {
                    var alternativePath = indexPath.row - 1
                    let section = viewModel.sections[alternativePath]
                    cell.parentVC = self
                    cell.sectionNameLabel.text = section.name
                    cell.fillCollectionView(section: section)
                    return cell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.animeSectionTVCell.rawValue) as? AnimeSectionTableViewCell {
                cell.parentVC = self
                let section = viewModel.sections[indexPath.row]
                cell.sectionNameLabel.text = section.name
                cell.fillCollectionView(section: section)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}

