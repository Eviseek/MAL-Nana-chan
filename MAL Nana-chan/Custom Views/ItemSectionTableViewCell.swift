//
//  ItemSectionTableViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit
import AlamofireImage

class ItemSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var itemSectionNameLabel: UILabel!
    @IBOutlet weak var itemSeeAllButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var itemCollectionViewHeight: NSLayoutConstraint!
    
    var items: [Item] = []
    var height = 0
    
    var parentVC: UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let nib = UINib(nibName: Identifiers.ItemCollectionViewCell.rawValue, bundle: nil)
        itemCollectionView.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
        
        itemCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        print(itemCollectionViewHeight)
        
        
    }
    
    func fillCollectionView(items: [Item]) {
        self.items = items
        itemCollectionView.reloadData()
    }
}

extension ItemSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell {
            cell.itemTitleLabel.text = items[indexPath.item].title
            if let score = items[indexPath.row].score {
                cell.itemRankLabel.text = score.description
            }
            if let downloadedImg = URL(string: items[indexPath.item].image ?? "") {
                cell.itemImageView.af.setImage(withURL: downloadedImg)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}


extension ItemSectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Sizes.itemCollectionViewCellWidth.rawValue, height: Sizes.itemCollectionViewCellHeight.rawValue)
    }
    
}
