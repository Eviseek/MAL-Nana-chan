//
//  ItemDetailViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 06.02.2023.
//

import Foundation
import UIKit
import AlamofireImage

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var relatedAnimeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var relatedMangaCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recommendationsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var titlesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var synonymsListLabel: UILabel!
    @IBOutlet weak var englishListLabel: UILabel!
    @IBOutlet weak var japaneseListLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var mainImageImageView: UIImageView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var relatedAnimeCollectionView: UICollectionView!
    @IBOutlet weak var relatedMangaCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    

    var id: Int? = nil
    var viewModel: ItemDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ItemDetailViewModel(viewController: self)
        
        let nib = UINib(nibName: Identifiers.GenreCollectionViewCell.rawValue, bundle: nil)
        genreCollectionView.register(nib, forCellWithReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue)
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        
        let relatedNib = UINib(nibName: Identifiers.ItemCollectionViewCell.rawValue, bundle: nil)
        relatedAnimeCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue)
        relatedAnimeCollectionView.dataSource = self
        relatedAnimeCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        
        relatedMangaCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue)
        relatedMangaCollectionView.dataSource = self
        relatedMangaCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        
        recommendationsCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue)
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
    }
    
    func updateView() {
        itemNameLabel.text = viewModel?.anime?.title
        if let score = viewModel?.anime?.mean {
            scoreLabel.text = score.description
        }
        if let url = URL(string: viewModel?.anime?.main_picture?.medium ?? "") {
            mainImageImageView.af.setImage(withURL: url)
        }
        typeLabel.text = viewModel?.anime?.media_type?.getType()
        statusLabel.text = viewModel?.anime?.status?.getStatus()
        episodesLabel.text = viewModel?.anime?.num_episodes?.description
        //TODO: lepe osetrit duration
        durationLabel.text = (viewModel?.anime?.average_episode_duration ?? 0 / 60).description
        if viewModel?.anime?.synopsis != "" {
            synopsisTextView.text = viewModel?.anime?.synopsis
        } else {
            synopsisTextView.text = "No synopsis"
        }
        synopsisTextView.sizeToFit()
        if let season = viewModel?.anime?.start_season?.season.stringValue(), let year = viewModel?.anime?.start_season?.year {
            seasonLabel.text = "\(season) \(year)"
        }
        genreCollectionView.reloadData()
        relatedAnimeCollectionView.reloadData()
        relatedMangaCollectionView.reloadData()
        recommendationsCollectionView.reloadData()
    }
    
    func noData() {
    }
    
    @IBAction func openOpeningsAndEndings(_ sender: UIButton) {
        //TODO: send action to viewModel
    }
    
    @IBAction func openMoreInformation(_ sender: UIButton) {
        //TODO: send action to viewModel
    }
    
}

extension ItemDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView {
            return viewModel?.anime?.genres?.count ?? 0
        }
//        if collectionView == relatedAnimeCollectionView {
//            return viewModel?.anime?.related_anime?.count ?? 0
//        }
//        if collectionView == relatedMangaCollectionView {
//            return viewModel?.anime?.related_manga?.count ?? 0
//        }
//        if collectionView == recommendationsCollectionView {
//            return viewModel?.anime?.recommendations?.count ?? 0
  //      }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue, for: indexPath) as? GenreCollectionViewCell {
                cell.genreLabel.text = viewModel?.anime?.genres?[indexPath.item].name
                collectionViewHeight.constant = collectionView.contentSize.height //TODO: lepsi umisteni?
                return cell
            }
        }
        
        if collectionView == relatedAnimeCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue, for: indexPath) as? ItemCollectionViewCell {
//                var item = viewModel?.anime?.related_anime?[indexPath.item]
//                cell.itemTypeView.isHidden = false
//                cell.itemTitleLabel.text = item?.node.title
//                if let url = URL(string: item?.node.main_picture?.medium ?? "") {
//                    cell.itemImageView.af.setImage(withURL: url)
//                }
//                cell.itemTypeLabel.text = item?.relation_type_formatted
                return cell
            }
        }
        
        if collectionView == relatedMangaCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue, for: indexPath) as? ItemCollectionViewCell {
//                if let item = viewModel?.anime?.related_manga?[indexPath.item] {
//                    cell.itemTypeView.isHidden = false
//                    cell.itemTitleLabel.text = item.node.title
//                    if let url = URL(string: item.node.main_picture?.medium ?? "") {
//                        cell.itemImageView.af.setImage(withURL: url)
//                    }
//                    cell.itemTypeLabel.text = item.relation_type_formatted
            //    }
                return cell
            }
        }
        
        if collectionView == recommendationsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue, for: indexPath) as? ItemCollectionViewCell {
//                var item = viewModel?.anime?.recommendations?[indexPath.item]
//                cell.itemTypeView.isHidden = true
//                cell.itemTitleLabel.text = item?.node.title
//                if let url = URL(string: item?.node.main_picture?.medium ?? "") {
//                    cell.itemImageView.af.setImage(withURL: url)
//                }
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == relatedAnimeCollectionView || collectionView == relatedMangaCollectionView || collectionView == recommendationsCollectionView {
            return CGSize(width: Sizes.itemCollectionViewCellWidth.rawValue, height: Sizes.itemCollectionViewCellHeight.rawValue)
        }
        return CGSize()
    }
}
