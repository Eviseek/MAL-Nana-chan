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
    @IBOutlet weak var synopsisTextviewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var titlesViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mainImageImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    
    @IBOutlet weak var synonymsListLabel: UILabel!
    @IBOutlet weak var englishListLabel: UILabel!
    @IBOutlet weak var japaneseListLabel: UILabel!
    
    
    var id: Int? = nil
    
    var viewModel: ItemDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ItemDetailViewModel(viewController: self)
        
        let nib = UINib(nibName: Identifiers.GenreCollectionViewCell.rawValue, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func updateView() {
        itemNameLabel.text = viewModel?.anime?.title
        scoreLabel.text = viewModel?.anime?.mean?.description
        if let url = URL(string: viewModel?.anime?.main_picture?.medium ?? "") {
            mainImageImageView.af.setImage(withURL: url)
        }
        typeLabel.text = viewModel?.anime?.media_type?.getType()
        statusLabel.text = viewModel?.anime?.status?.getStatus()
        episodesLabel.text = viewModel?.anime?.num_episodes?.description
        //TODO: lepe osetrit duration
        durationLabel.text = (viewModel?.anime?.average_episode_duration ?? 0 / 60).description
        synopsisTextView.text = viewModel?.anime?.synopsis
        synopsisTextView.sizeToFit()
        if let season = viewModel?.anime?.start_season?.season.getSeason(), let year = viewModel?.anime?.start_season?.year {
            seasonLabel.text = "\(season) \(year)"
        }
        collectionView.reloadData()
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
        print("Got genres \(viewModel?.anime?.genres)")
        return viewModel?.anime?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.GenreCollectionViewCell.rawValue, for: indexPath) as? GenreCollectionViewCell {
            cell.genreLabel.text = viewModel?.anime?.genres?[indexPath.item].name
            collectionViewHeight.constant = collectionView.contentSize.height //TODO: lepsi umisteni?
            return cell
        }
        return UICollectionViewCell()
    }
}
