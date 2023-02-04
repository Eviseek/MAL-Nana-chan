//
//  ItemSectionTableViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit

class ItemSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var itemSectionNameLabel: UILabel!
    @IBOutlet weak var itemSeeAllButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    var items: [Item] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let nib = UINib(nibName: Identifiers.ItemCollectionViewCell.rawValue, bundle: nil)
        itemCollectionView.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        itemCollectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    
    
}
