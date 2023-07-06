//
//  AnimelistDetailViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 30.06.2023.
//

import UIKit

class AnimelistDetailViewController: UIViewController {
    
    //UI buttons
    @IBOutlet weak var planToWatchButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var onHoldButton: UIButton!
    @IBOutlet weak var watchingButton: UIButton!
    @IBOutlet weak var droppedButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var statusContentView: UIView!
    
    //UI labels
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemStatusLabel: UILabel!
    @IBOutlet weak var itemEpisodesNumLabel: UILabel!
    
    @IBOutlet weak var itemScoreTextField: UITextField!
    
    private let manager = UserAnimeStatusManager()
    private let viewModel = AnimelistDetailViewModel()
    
    var anime: Anime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let anime = anime else { return }
        viewModel.viewDidLoad(vc: self, anime: anime)
        setUpButtonTags()
        
    }
    
    private func setUpButtonTags() {
        planToWatchButton.tag = 5
        completedButton.tag = 1
        onHoldButton.tag = 2
        watchingButton.tag = 3
        droppedButton.tag = 4
    }
    
    //TODO: move to model?
    //function that is accessing statusView and its stackViews to find buttons and change their appearance
    func changeButtonsState(_ selected: Int) {
        for subview in statusContentView.subviews { //accessing subviews of statusContentView
            if subview is UIStackView { //if subviews is stackView then access it again
                for button in subview.subviews {
                    if button is UIButton { //find button in stackView
                        if let button = button as? UIButton {
                            changeButtonAppearance(button, selected) //change its appearance
                        }
                    }
                }
            } else if subview is UIButton { //one button is not in stack view, so change appearance of this one as well
                if let button = subview as? UIButton {
                    changeButtonAppearance(button, selected)
                }
            }
        }
    }
    
    private func changeButtonAppearance(_ button: UIButton, _ selected: Int) {
        if button.tag == selected {
            button.backgroundColor = UIColor(named: "mal_color")
            button.tintColor = .white
        } else {
            button.backgroundColor = .systemGray5
            button.tintColor = UIColor(named: "mal_color")
        }
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        print("selected tag is \(sender.tag)")
        let selectedTag = sender.tag
        changeButtonsState(selectedTag)
        viewModel.selectedState = manager.getStatusForTag(selectedTag)
    }
    
    
    
}
