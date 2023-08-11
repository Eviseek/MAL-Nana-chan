//
//  ItemListTableViewCell.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 20.03.2023.
//

import UIKit

class AnimePreviewTableViewCell: UITableViewCell {

    //UI ImageViews
    @IBOutlet weak var itemImageView: UIImageView!
    
    //UI Labels
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodesNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodesTitleLabel: UILabel!
    
    //UI Views
    @IBOutlet weak var typeContainerView: UIView!
    @IBOutlet weak var myListView: UIView!
    
    //UI Buttons
    @IBOutlet weak var myListButton: UIButton!
    
    var anime: Anime? = nil
    var vc: UIViewController? = nil
    var storyboard: UIStoryboard? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeContainerView.layer.cornerRadius = 5
        
        myListView.layer.cornerRadius = 5
        myListView.layer.borderWidth = 1
        myListView.layer.borderColor = UIColor(named: "mal_color")?.cgColor
        
        if !TokenHandler.isUserLoggedIn {
            myListView.isHidden = true
        }
    }
    
    func updateEpisodesLabel(number: Int) {
        if number == 1 {
            episodesTitleLabel.text = "episode"
        } else {
            episodesTitleLabel.text = "episodes"
        }
    }
    
    @IBAction func myListClicked(_ sender: UIButton) {
        
        if vc?.storyboard == nil {
            print("storyboard was nil")
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        } else {
            print("there was a storyboard")
            storyboard = vc?.storyboard
        }
        
        if let picker = storyboard?.instantiateViewController(withIdentifier: "MyAnimeStatusViewController") as? MyAnimeStatusViewController {
            print("i am here")
        if let sheet = picker.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        picker.anime = anime
      //  picker.fromAnimelist = false
        vc?.present(picker, animated: true)
        }
    }
}
