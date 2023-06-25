//
//  RecommendationTableViewCell.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 25.06.2023.
//

import UIKit

class RecommendationTableViewCell: UITableViewCell {

    //left recommendation outlets
    @IBOutlet weak var leftRecImageView: UIImageView!
    @IBOutlet weak var leftRecTitleLabel: UILabel!
    @IBOutlet weak var leftRecScoreLabel: UILabel!
    @IBOutlet weak var leftRecTypeLabel: UILabel!
    
    //right recommendation outlets
    @IBOutlet weak var rightRecImageView: UIImageView!
    @IBOutlet weak var rightRecItemLabel: UILabel!
    @IBOutlet weak var rightRecScoreLabel: UILabel!
    @IBOutlet weak var rightRecTypeLabel: UILabel!
    
  //  var parentVC: ExploreViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
