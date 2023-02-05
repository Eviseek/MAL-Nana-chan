//
//  ItemCollectionViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    @IBOutlet weak var itemRankLabel: UILabel!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //TODO: zeptat se proc to takto nejde
//        cellHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
//        print(Sizes.itemCollectionViewCellHeight.rawValue)
//        cellWidth.constant = Sizes.itemCollectionViewCellWidth.rawValue
        
        // Initialization code
    }

}
