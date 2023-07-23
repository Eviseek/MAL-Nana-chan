//
//  ItemCollectionViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit
import SkeletonView

class AnimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var animeTitleLabel: UILabel!
    
    @IBOutlet weak var animeScoreLabel: UILabel!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    @IBOutlet weak var animeTypeView: UIView!
    @IBOutlet weak var animeTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.showSkeleton()
        
        //TODO: zeptat se proc to takto nejde
//        cellHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
//        print(Sizes.itemCollectionViewCellHeight.rawValue)
//        cellWidth.constant = Sizes.itemCollectionViewCellWidth.rawValue
        
        // Initialization code
    }

}
