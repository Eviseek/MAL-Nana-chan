//
//  ItemListTableViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 20.03.2023.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodesNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodesTitleLabel: UILabel!
    
    @IBOutlet weak var typeContainerView: UIView!
    
    @IBOutlet weak var myListView: UIView!
    @IBOutlet weak var myListButton: UIButton!
    
    var item: Anime? = nil
    var vc: UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        typeContainerView.layer.cornerRadius = 5
        
        myListView.layer.cornerRadius = 5
        myListView.layer.borderWidth = 1
        myListView.layer.borderColor = UIColor(named: "mal_color")?.cgColor
        
        if !TokenHandler.isUserLoggedIn {
            myListView.isHidden = true
        }
        
    }
    
    func updateEpisodesLabel(type: ItemType, number: Int) {
        if type == .anime {
            if number == 1 {
                episodesTitleLabel.text = "episode"
            } else {
                episodesTitleLabel.text = "episodes"
            }
        }
        
        if type == .manga {
            //TODO
        }
    }
    
    @IBAction func myListClicked(_ sender: UIButton) {
        if let picker = vc?.storyboard?.instantiateViewController(withIdentifier: "MyListViewController") as? MyListViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            picker.anime = item
            picker.fromAnimelist = false
            vc?.present(picker, animated: true)
        }
    }
}
