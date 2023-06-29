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
    @IBOutlet weak var seeAllButton: UIButton!
    
    var height = 0
    var itemSection: Section? = nil
    
    var parentVC: UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemSeeAllButton.layer.cornerRadius = 5
        
        let nib = UINib(nibName: Identifiers.ItemCollectionViewCell.rawValue, bundle: nil)
        itemCollectionView.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
        
        itemCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        
    }
    
    @IBAction func seeAllButtonClicked(_ sender: UIButton) {
        if let seeAllVC = parentVC?.storyboard?.instantiateViewController(withIdentifier: "SeeAllViewController") as? SeeAllViewController {
            seeAllVC.sectionContent = itemSection
            parentVC?.navigationController?.pushViewController(seeAllVC, animated: true)
        }
    }
    
    func itemSelected(id: Int) {
        print("item selected")
        if let controller = parentVC?.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
            print("success, will be pushing")
            controller.id = id
            parentVC?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func fillCollectionView(section: Section) {
        self.itemSection = section
        print("collection view \(section)")
        itemCollectionView.reloadData()
    }
    
}

extension ItemSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemSection?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell {
            var item = itemSection?.items[indexPath.item]
            cell.itemTitleLabel.text = item?.title
            if let score = item?.score {
                cell.itemRankLabel.text = score.description
            }
            if let downloadedImg = URL(string: item?.image ?? "") {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     //   print("selected \(items[indexPath.item].id)")
        itemSelected(id: itemSection?.items[indexPath.item].id ?? 0)
    }
    
}
