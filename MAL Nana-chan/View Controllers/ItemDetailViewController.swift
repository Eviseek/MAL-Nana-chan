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
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var recommendationsContainerView: UIView!
    @IBOutlet weak var relatedMangaContainerView: UIView!
    @IBOutlet weak var relatedAnimeContainerView: UIView!
    
    var id: Int? = nil
    var viewModel: ItemDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.layer.cornerRadius = 5
        
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
        let anime = viewModel?.anime
        itemNameLabel.text = anime?.title
        if let score = anime?.score {
            scoreLabel.text = score.description
        }
        if let url = URL(string: anime?.mainPicture?.medium ?? "") {
            mainImageImageView.af.setImage(withURL: url)
        }
        typeLabel.text = anime?.mediaType?.getType()
        statusLabel.text = anime?.status?.getStatus()
        episodesLabel.text = anime?.episodesCount?.description
        //TODO: lepe osetrit duration
        if let secs = anime?.episodeDurationSec {
            durationLabel.text = (secs/60).description
        }
        if anime?.synopsis != "" {
            synopsisTextView.text = anime?.synopsis
        } else {
            synopsisTextView.text = "No synopsis"
        }
        synopsisTextView.sizeToFit()
        if let season = anime?.startSeason?.season.stringValue(), let year = anime?.startSeason?.year {
            seasonLabel.text = "\(season) \(year)"
        }
        var synonymsText = ""
        for synonyms in anime?.alternativeTitle?.synonyms ?? [] {
            synonymsText.append(synonyms + ", ")
        }
        synonymsListLabel.text = synonymsText
        englishListLabel.text = anime?.alternativeTitle?.en ?? "None"
        japaneseListLabel.text = anime?.alternativeTitle?.ja ?? "None"
        genreCollectionView.reloadData()
        
        if anime?.relatedAnime?.isEmpty ?? true {
            print(anime?.relatedAnime)
            relatedAnimeContainerView.removeFromSuperview()
        } else {
            print("many related anime")
            relatedAnimeCollectionView.reloadData()
        }
        
        if anime?.relatedManga?.isEmpty ?? true {
            relatedMangaContainerView.removeFromSuperview()
        } else {
            relatedMangaCollectionView.reloadData()
        }
        
        if anime?.recommendations?.isEmpty ?? true {
            recommendationsContainerView.removeFromSuperview()
        } else {
            recommendationsCollectionView.reloadData()
        }
        
    }
    
    func noData() {
    }
    
    @IBAction func openOpeningsAndEndings(_ sender: UIButton) {
        //TODO: send action to viewModel
    }
    
    @IBAction func openMoreInformation(_ sender: UIButton) {
        //TODO: send action to viewModel
    }
    
    @IBAction func addToList(_ sender: UIButton) {
        viewModel?.addToListClicked()
    }
    
    
}

extension ItemDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView {
            return viewModel?.anime?.genres?.count ?? 0
        }
        if collectionView == relatedAnimeCollectionView {
            return viewModel?.anime?.relatedAnime?.count ?? 0
        }
        if collectionView == relatedMangaCollectionView {
            print("erlated MANGA is \(viewModel?.anime?.relatedManga)")
            return viewModel?.anime?.relatedManga?.count ?? 0
        }
        if collectionView == recommendationsCollectionView {
            return viewModel?.anime?.recommendations?.count ?? 0
        }
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
                var item = viewModel?.anime?.relatedAnime?[indexPath.item]
                cell.itemTypeView.isHidden = false
                cell.itemTitleLabel.text = item?.node.title
                if let url = URL(string: item?.node.mainPicture?.medium ?? "") {
                    cell.itemImageView.af.setImage(withURL: url)
                }
                cell.itemTypeLabel.text = item?.relation_type_formatted
                return cell
            }
        }
        
        if collectionView == relatedMangaCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue, for: indexPath) as? ItemCollectionViewCell {
                if let item = viewModel?.anime?.relatedManga?[indexPath.item] {
                    cell.itemTypeView.isHidden = false
                    cell.itemTitleLabel.text = item.node.title
                    if let url = URL(string: item.node.mainPicture?.medium ?? "") {
                        cell.itemImageView.af.setImage(withURL: url)
                    }
                    cell.itemTypeLabel.text = item.relation_type_formatted
                }
                return cell
            }
        }
        
        if collectionView == recommendationsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue, for: indexPath) as? ItemCollectionViewCell {
                var item = viewModel?.anime?.recommendations?[indexPath.item]
                cell.itemTypeView.isHidden = true
                cell.itemTitleLabel.text = item?.node.title
                if let url = URL(string: item?.node.mainPicture?.medium ?? "") {
                    cell.itemImageView.af.setImage(withURL: url)
                }
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
