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
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressBar.gradientColors = [.gray, .blue]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setProgress(_ progress: Int, total: Int) {
        if total != 0 {
            let value = progress/total
            progressBar.setProgress(Float(value), animated: false)
            progressLabel.text = value.description
        } else {
            progressBar.setProgress(Float(progress), animated: false)
        }
        
    }
    
    
}
