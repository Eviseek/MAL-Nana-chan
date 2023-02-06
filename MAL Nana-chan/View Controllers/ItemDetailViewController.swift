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
    
    var id: Int? = nil
    
    var viewModel: ItemDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ItemDetailViewModel(viewController: self)
        
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
        durationLabel.text = viewModel?.anime?.average_episode_duration?.description
        synopsisTextView.text = viewModel?.anime?.synopsis
        seasonLabel.text = "\(viewModel?.anime?.start_season?.season.getSeason()) \(viewModel?.anime?.start_season?.year.description)"
        //TODO: episodes, season, duration, synopsis
        
    }
    
    func noData() {
        
    }
    
    
}
