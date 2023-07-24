//
//  ItemSectionTableViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import UIKit
import AlamofireImage

class AnimeSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var sectionSeeAllButton: UIButton!
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    @IBOutlet weak var sectionCollectionViewHeight: NSLayoutConstraint!
    
    var height = 0
    var itemSection: Section<Anime>? = nil
    
    var parentVC: UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sectionSeeAllButton.layer.cornerRadius = 5
        
        let nib = UINib(nibName: Identifiers.animeCVCell.rawValue, bundle: nil)
        sectionCollectionView.register(nib, forCellWithReuseIdentifier: "AnimeCollectionViewCell")
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        
        sectionCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        
    }
    
    @IBAction func seeAllButtonClicked(_ sender: UIButton) {
        if let seeAllVC = parentVC?.storyboard?.instantiateViewController(withIdentifier: "SeeAllViewController") as? SeeAllViewController<Anime> {
            seeAllVC.section = itemSection
            parentVC?.navigationController?.pushViewController(seeAllVC, animated: true)
        }
    }
    
    func itemSelected(id: Int) {
        if let controller = parentVC?.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailViewController") as? AnimeDetailViewController {
            print("success, will be pushing")
            controller.id = id
            parentVC?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func fillCollectionView(section: Section<Anime>) {
        self.itemSection = section
        print("collection view \(section)")
        sectionCollectionView.reloadData()
    }
    
}

extension AnimeSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemSection?.response.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeCollectionViewCell", for: indexPath) as? AnimeCollectionViewCell {
            var item = itemSection?.response.data[indexPath.item].node
            cell.animeTitleLabel.text = item?.title
            if let score = item?.score {
                cell.animeScoreLabel.text = score.description
            }
            if let downloadedImg = URL(string: item?.mainPicture?.medium ?? "") {
                cell.animeImageView.af.setImage(withURL: downloadedImg)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}


extension AnimeSectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Sizes.itemCollectionViewCellWidth.rawValue, height: Sizes.itemCollectionViewCellHeight.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(itemSection?.response.data[indexPath.item].node.id)")
        itemSelected(id: itemSection?.response.data[indexPath.item].node.id ?? 0)
    }
    
}
