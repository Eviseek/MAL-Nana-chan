//
//  AnimelistItemTableViewCell.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 30.06.2023.
//

import UIKit

class AnimelistItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var itemScoreLabel: UILabel!
    @IBOutlet weak var itemSeasonLabel: UILabel!
    @IBOutlet weak var itemStatusLabel: UILabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemListStatusLabel: UILabel!
    @IBOutlet weak var itemListScoreLabel: UILabel!
    @IBOutlet weak var itemListProgressLabel: UILabel!
    @IBOutlet weak var itemListPriorityLabel: UILabel!
    
    @IBOutlet weak var myListView: UIView!
    
    weak var parentVC: AnimelistViewController? = nil
    var anime: Anime? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myListView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func listButtonClicked(_ sender: UIButton) {
        if let picker = parentVC?.storyboard?.instantiateViewController(withIdentifier: "MyAnimeStatusViewController") as? MyAnimeStatusViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.large()]
            }
            picker.anime = anime
            picker.fromAnimelist = true
            parentVC?.present(picker, animated: true)
        }
    }
    
}
