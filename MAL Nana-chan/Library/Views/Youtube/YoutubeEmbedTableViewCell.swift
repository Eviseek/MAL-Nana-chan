//
//  YoutubeEmbedTableViewCell.swift
//  MAL Nana-chan
//

import UIKit
import YouTubeiOSPlayerHelper

/// Embedded trailer player for the Home screen.
final class YoutubeEmbedTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var playerView: YTPlayerView!

    /// Tracks what is loaded so a table reload doesn't restart playback.
    private var loadedVideoID: String?

    func configure(videoID: String) {
        guard loadedVideoID != videoID else { return }
        loadedVideoID = videoID
        playerView.load(withVideoId: videoID)
    }
}
