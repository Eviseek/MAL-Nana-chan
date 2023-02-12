//
//  GenreCollectionViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 12.02.2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genreView.layer.cornerRadius = 8
        
    }

}
