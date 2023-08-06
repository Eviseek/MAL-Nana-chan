//
//  AnimeDetailViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 06.02.2023.
//

import Foundation
import UIKit
import AlamofireImage

class AnimeDetailViewController: UIViewController {
    
    @IBOutlet weak var seeMoreSynopsisLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var relatedAnimeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var relatedMangaCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recommendationsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var titlesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var synopsisTextViewHeight: NSLayoutConstraint!
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
    
    @IBOutlet weak var seeMoreButton: UIButton!
    
    var id: Int? = nil
    private var viewModel = AnimeDetailViewModel()
    private var contentSize: Double = 150.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel.viewDidLoad(viewController: self)
        setUpViews()
        print("synopsis content size \(synopsisTextView.contentSize.height)")
    }
    
    private func setUpViews() {
        infoView.layer.cornerRadius = 5
        
        let nib = UINib(nibName: Identifiers.GenreCollectionViewCell.rawValue, bundle: nil)
        genreCollectionView.register(nib, forCellWithReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue)
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        
        let relatedNib = UINib(nibName: Identifiers.animeCVCell.rawValue, bundle: nil)
        relatedAnimeCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.animeCVCell.rawValue)
        relatedAnimeCollectionView.dataSource = self
        relatedAnimeCollectionView.delegate = self
        relatedAnimeCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        
        relatedMangaCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.animeCVCell.rawValue)
        relatedMangaCollectionView.dataSource = self
        relatedMangaCollectionView.delegate = self
        relatedMangaCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
        
        recommendationsCollectionView.register(relatedNib, forCellWithReuseIdentifier: Identifiers.animeCVCell.rawValue)
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self
        recommendationsCollectionViewHeight.constant = Sizes.itemCollectionViewCellHeight.rawValue
    }
    
    func updateView() {
        let anime = viewModel.anime
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
        
        contentSize = synopsisTextView.contentSize.height //saving contentSize to use it with expand later
        if synopsisTextView.contentSize.height < 150 {
            synopsisTextViewHeight.constant = synopsisTextView.contentSize.height
            seeMoreSynopsisLabel.removeFromSuperview()
        }
        
    }
    
    func noData() {
    }
    
    @IBAction func openOpeningsAndEndings(_ sender: UIButton) {
        viewModel.openingsEndingsButtonClicked()
    }
    
    @IBAction func openMoreInformation(_ sender: UIButton) {
        viewModel.openMoreInformation()
    }
    
    @IBAction func addToList(_ sender: UIButton) {
        viewModel.addToListClicked()
    }
    
    @IBAction func seeMoreSynopsisButton(_ sender: UIButton) {
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
    
}

extension AnimeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView {
            return viewModel.anime?.genres?.count ?? 0
        }
        if collectionView == relatedAnimeCollectionView {
            return viewModel.anime?.relatedAnime?.count ?? 0
        }
        if collectionView == relatedMangaCollectionView {
            print("erlated MANGA is \(viewModel.anime?.relatedManga)")
            return viewModel.anime?.relatedManga?.count ?? 0
        }
        if collectionView == recommendationsCollectionView {
            return viewModel.anime?.recommendations?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue, for: indexPath) as? GenreCollectionViewCell {
                cell.genreLabel.text = viewModel.anime?.genres?[indexPath.item].name
                collectionViewHeight.constant = collectionView.contentSize.height //TODO: lepsi umisteni?
                return cell
            }
        }
        
        if collectionView == relatedAnimeCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.animeCVCell.rawValue, for: indexPath) as? AnimeCollectionViewCell {
                var anime = viewModel.anime?.relatedAnime?[indexPath.item].node
                cell.animeTypeView.isHidden = false
                cell.animeTitleLabel.text = anime?.title
                if let url = URL(string: anime?.mainPicture?.medium ?? "") {
                    cell.animeImageView.af.setImage(withURL: url)
                }
                cell.animeTypeLabel.text = viewModel.anime?.relatedAnime?[indexPath.row].relation_type_formatted
                return cell
            }
        }
        
        if collectionView == relatedMangaCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.mangaCVCell.rawValue, for: indexPath) as? MangaCollectionViewCell {
                if let manga = viewModel.anime?.relatedManga?[indexPath.item] {
                    cell.mangaTypeView.isHidden = false
                    cell.mangaTitleLabel.text = manga.node.title
                    if let url = URL(string: manga.node.mainPicture?.medium ?? "") {
                        cell.mangaImageView.af.setImage(withURL: url)
                    }
                    cell.mangaTypeLabel.text = manga.relation_type_formatted
                }
                return cell
            }
        }
        
        if collectionView == recommendationsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.animeCVCell.rawValue, for: indexPath) as? AnimeCollectionViewCell {
                var anime = viewModel.anime?.recommendations?[indexPath.item]
                cell.animeTypeView.isHidden = true
                cell.animeTitleLabel.text = anime?.node.title
                if let url = URL(string: anime?.node.mainPicture?.medium ?? "") {
                    cell.animeImageView.af.setImage(withURL: url)
                }
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCollectionViewItem(at: indexPath.item, cv: collectionView)
        print("selectedItemAt \(indexPath.item)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == relatedAnimeCollectionView || collectionView == relatedMangaCollectionView || collectionView == recommendationsCollectionView {
            return CGSize(width: Sizes.itemCollectionViewCellWidth.rawValue, height: Sizes.itemCollectionViewCellHeight.rawValue)
        }
        return CGSize()
    }
}
