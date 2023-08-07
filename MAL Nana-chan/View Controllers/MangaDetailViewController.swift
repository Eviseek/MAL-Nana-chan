//
//  MangaDetailViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 16.07.2023.
//

import UIKit
import AlamofireImage

class MangaDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var volumesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var chaptersLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var genresCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var seeMoreButton: UIButton!
    
    @IBOutlet weak var synonymsLabel: UILabel!
    @IBOutlet weak var enSynonymsLabel: UILabel!
    @IBOutlet weak var jpSynonymsLabel: UILabel!
    
    @IBOutlet weak var relatedAnimeContainerView: UIView!
    @IBOutlet weak var relatedMangaContainerView: UIView!
    @IBOutlet weak var recommendationsContainerView: UIView!
    
    @IBOutlet weak var relatedAnimeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var relatedMangaCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recommendationsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var synopsisTextViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var relatedAnimeCollectionView: UICollectionView!
    @IBOutlet weak var relatedMangaCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    private var viewModel = MangaDetailViewModel()
    var id: Int?
    
    private var manga: Manga?
    private var contentSize: Double = 150.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = id else { return } //TODO: show alert and then dismiss controller
        
        setUpController()
        viewModel.viewDidLoad(vc: self, id: id)
    }
    
    private func setUpController() {
        infoView.layer.cornerRadius = 5
        
        let nib = UINib(nibName: Identifiers.GenreCollectionViewCell.rawValue, bundle: nil)
        genresCollectionView.register(nib, forCellWithReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue)
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
        
        let relatedNib = UINib(nibName: Identifiers.animeCVCell.rawValue, bundle: nil)
        relatedAnimeCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.animeCVCell.rawValue)
        relatedAnimeCollectionView.dataSource = self
        relatedAnimeCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        
        relatedMangaCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.animeCVCell.rawValue)
        relatedMangaCollectionView.dataSource = self
        relatedMangaCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        
        recommendationsCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.animeCVCell.rawValue)
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
    }
    
    func updateViewWith(_ manga: Manga) {
        self.manga = manga
        nameLabel.text = manga.title
        if let url = URL(string: manga.mainPicture?.medium ?? "") {
            pictureImageView.af.setImage(withURL: url)
        }
        scoreLabel.text = manga.score?.description ?? "N/A"
        typeLabel.text = manga.mediaType?.getType()
        print("media type \(manga.mediaType)")
        statusLabel.text = manga.status?.getStatus()
        volumesLabel.text = manga.volumesCount?.description ?? "N/A"
        chaptersLabel.text = manga.chaptersCount?.description ?? "N/A"
        
        if let synopsis = manga.synopsis, !(synopsis.isEmpty) {
            synopsisTextView.text = synopsis
        } else {
            synopsisTextView.text = "No synopsis"
        }
        
        synopsisTextView.sizeToFit()
        
        var synonyms = ""
        for synonym in manga.alternativeTitles?.synonyms ?? [String]() {
            synonyms += synonym + ", "
        }
        
        if !(synonyms.isEmpty) {
            synonymsLabel.text = synonyms
        }
        
        if let alternatives = manga.alternativeTitles?.en, !(alternatives.isEmpty) {
            enSynonymsLabel.text = alternatives
        }
        
        if let jp = manga.alternativeTitles?.ja, !(jp.isEmpty) {
            jpSynonymsLabel.text = jp
        }
        
        genresCollectionView.reloadData()
        relatedAnimeCollectionView.reloadData()
        relatedMangaCollectionView.reloadData()
        recommendationsCollectionView.reloadData()
        
        contentSize = synopsisTextView.contentSize.height //saving contentSize to use it with expand later
        if synopsisTextView.contentSize.height < 150 {
            synopsisTextViewHeight.constant = synopsisTextView.contentSize.height
            seeMoreButton.removeFromSuperview()
        }
        
    }
    
    @IBAction func seeMoreSynopsisButtonClicked(_ sender: UIButton) {
        if synopsisTextViewHeight.constant <= 150 {
            synopsisTextViewHeight.constant = contentSize
            seeMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            seeMoreButton.setTitle("See less", for: .normal)
        } else {
            synopsisTextViewHeight.constant = 150
            seeMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            seeMoreButton.setTitle("See more", for: .normal)
        }
    }
    
    @IBAction func myListButtonClicked(_ sender: UIButton) {
        viewModel.addToListClicked()
    }
    
    @IBAction func seeMoreInfoButtonClicked(_ sender: UIButton) {
        viewModel.seeMoreInfoButtonClicked()
    }
    
}

extension MangaDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genresCollectionView {
            print("manga genres \(manga?.genres)")
            return manga?.genres?.count ?? 0
        }
        if collectionView == relatedAnimeCollectionView {
            return manga?.relatedAnime?.count ?? 0
        }
        if collectionView == relatedMangaCollectionView {
            print("related MANGA is \(manga?.relatedManga)")
            return manga?.relatedManga?.count ?? 0
        }
        if collectionView == recommendationsCollectionView {
            return manga?.recommendations?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genresCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue, for: indexPath) as? GenreCollectionViewCell {
                cell.genreLabel.text = manga?.genres?[indexPath.item].name
                genresCollectionViewHeight.constant = collectionView.contentSize.height //TODO: lepsi umisteni?
                return cell
            }
        }
        
        if collectionView == relatedAnimeCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.animeCVCell.rawValue, for: indexPath) as? AnimeCollectionViewCell {
                var item = manga?.relatedAnime?[indexPath.item]
//                cell.itemTypeView.isHidden = false
//                cell.itemTitleLabel.text = item?.node.title
//                if let url = URL(string: item?.node.mainPicture?.medium ?? "") {
//                    cell.itemImageView.af.setImage(withURL: url)
//                }
//                cell.itemTypeLabel.text = item?.relation_type_formatted
                return cell
            }
        }
        
        if collectionView == relatedMangaCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.animeCVCell.rawValue, for: indexPath) as? AnimeCollectionViewCell {
//                if let item = manga?.relatedManga?[indexPath.item] {
//                    cell.itemTypeView.isHidden = false
//                    cell.itemTitleLabel.text = item.node.title
//                    if let url = URL(string: item.node.mainPicture?.medium ?? "") {
//                        cell.itemImageView.af.setImage(withURL: url)
//                    }
//                    cell.itemTypeLabel.text = item.relation_type_formatted
//                }
                return cell
            }
        }
        
        if collectionView == recommendationsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.animeCVCell.rawValue, for: indexPath) as? AnimeCollectionViewCell {
//                var item = manga?.recommendations?[indexPath.item]
//                cell.itemTypeView.isHidden = true
//                cell.itemTitleLabel.text = item?.node.title
//                if let url = URL(string: item?.node.mainPicture?.medium ?? "") {
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
