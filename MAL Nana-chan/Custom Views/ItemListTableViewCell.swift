//
//  ItemListTableViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 20.03.2023.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodesNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodesTitleLabel: UILabel!
    
    @IBOutlet weak var typeContainerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        typeContainerView.layer.cornerRadius = 5
    }
    
    func updateEpisodesLabel(type: ItemTypes, number: Int) {
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
    
}
