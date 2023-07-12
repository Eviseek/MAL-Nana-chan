//
//  AnimelistItemTableViewCell.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 30.06.2023.
//

import UIKit
import GradientProgressBar

class AnimelistItemTableViewCell: UITableViewCell {

    @IBOutlet weak var progressBar: GradientProgressBar!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var itemScoreLabel: UILabel!
    @IBOutlet weak var itemSeasonLabel: UILabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressBar.gradientColors = [.gray, .blue]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpProgress(progress: Float, total: Float?) {
        if let total = total {
            let value = progress/total
            progressBar.setProgress(value, animated: false)
        } else {
            progressBar.setProgress(0.5, animated: false)
        }
        
    }
    
    
}
