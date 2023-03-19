//
//  YoutubeEmbedTableViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import UIKit
import youtube_ios_player_helper

class YoutubeEmbedTableViewCell: UITableViewCell {

    @IBOutlet weak var playerView: YTPlayerView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpPlayer(with id: String) {
        playerView.load(withVideoId: id)
    }
    
}
