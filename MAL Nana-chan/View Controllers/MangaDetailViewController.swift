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
    @IBOutlet weak var seeMoreSynopsisButton: UIButton!
    
    @IBOutlet weak var synonymsLabel: UILabel!
    @IBOutlet weak var enSynonymsLabel: UILabel!
    @IBOutlet weak var jpSynonymsLabel: UILabel!
    
    @IBOutlet weak var relatedAnimeContainerView: UIView!
    @IBOutlet weak var relatedMangaContainerView: UIView!
    @IBOutlet weak var recommendationsContainerView: UIView!
    
    @IBOutlet weak var relatedAnimeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var relatedMangaCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recommendationsCollectionViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var relatedAnimeCollectionView: UICollectionView!
    @IBOutlet weak var relatedMangaCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    private var viewModel = MangaDetailViewModel()
    var id: Int?
    
    private var manga: Manga?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("manga id is \(id)")
        
        guard let id = id else { return } //TODO: show alert and then dismiss controller
        
        viewModel.viewDidLoad(vc: self, id: id)
    }
    
    private func setUpController() {
        infoView.layer.cornerRadius = 5
        
        let nib = UINib(nibName: Identifiers.GenreCollectionViewCell.rawValue, bundle: nil)
        genresCollectionView.register(nib, forCellWithReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue)
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
        
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
    
    func updateViewWith(_ manga: Manga) {
        self.manga = manga
        nameLabel.text = manga.title
        if let url = URL(string: manga.mainPicture?.medium ?? "") {
            pictureImageView.af.setImage(withURL: url)
        }
        scoreLabel.text = manga.score?.description ?? "N/A"
        typeLabel.text = manga.mediaType?.getType()
        statusLabel.text = manga.status?.getStatus()
        volumesLabel.text = manga.volumesCount?.description ?? "N/A"
        chaptersLabel.text = manga.chaptersCount?.description ?? "N/A"
        
        synopsisTextView.text = manga.synopsis
        
        var synonyms = ""
        for synonym in manga.alternativeTitles?.synonyms ?? [String]() {
            synonyms += synonym + ", "
        }
        synonymsLabel.text = synonyms
        
        enSynonymsLabel.text = manga.alternativeTitles?.en ?? "None"
        
        jpSynonymsLabel.text = manga.alternativeTitles?.ja ?? "None"
        
        genresCollectionView.reloadData()
        relatedAnimeCollectionView.reloadData()
        relatedMangaCollectionView.reloadData()
        recommendationsCollectionView.reloadData()
        
    }
    
    func noDataView() {
        
    }
    
    @IBAction func seeMoreSynopsisButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func myListButtonClicked(_ sender: UIButton) {
    }
    
}

extension MangaDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genresCollectionView {
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
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ItemCollectionViewCell.rawValue, for: indexPath) as? ItemCollectionViewCell {
                var item = manga?.relatedAnime?[indexPath.item]
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
                if let item = manga?.relatedManga?[indexPath.item] {
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
                var item = manga?.recommendations?[indexPath.item]
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
