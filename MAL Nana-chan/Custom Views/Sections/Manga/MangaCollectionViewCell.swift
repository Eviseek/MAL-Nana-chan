//
//  MangaCollectionViewCell.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.07.2023.
//

import UIKit

class MangaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mangaImageView: UIImageView!
    @IBOutlet weak var mangaTitleLabel: UILabel!
    
    @IBOutlet weak var mangaScoreLabel: UILabel!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    @IBOutlet weak var mangaTypeView: UIView!
    @IBOutlet weak var mangaTypeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
