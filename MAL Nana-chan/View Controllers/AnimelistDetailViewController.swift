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
        
        setUpButtonTags()
        setLabels(anime)
  
        viewModel.viewDidLoad(vc: self, anime: anime)
    }
    
    private func setUpButtonTags() {
        print("set up buttons tags")
        planToWatchButton.tag = manager.getTagForStatus(.planToWatch)
        print("tag for status plan to watch: \(manager.getTagForStatus(.planToWatch))")
        completedButton.tag = manager.getTagForStatus(.completed)
        onHoldButton.tag = manager.getTagForStatus(.onHold)
        watchingButton.tag = manager.getTagForStatus(.watching)
        droppedButton.tag = manager.getTagForStatus(.dropped)
    }
    
    private func setLabels(_ anime: Anime) {
        itemTitleLabel.text = anime.title
        itemStatusLabel.text = anime.status?.getStatus()
        itemEpisodesNumLabel.text = anime.episodesCount?.description
        itemScoreTextField.text = anime.myListStatus?.score.description ?? "0"
    }
    
    //TODO: move to model?
    //function that is accessing statusView and its stackViews to find buttons and change their appearance
//    func changeButtonsState(_ selectedTag: Int) {
//        for subview in statusContentView.subviews { //accessing subviews of statusContentView
//            if subview is UIStackView { //if subviews is stackView then access it again
//                for button in subview.subviews {
//                    if button is UIButton { //find button in stackView
//                        if let button = button as? UIButton {
//                            changeButtonAppearance(button, selectedTag) //change its appearance
//                        }
//                    }
//                }
//            } else if subview is UIButton { //one button is not in stack view, so change appearance of this one as well
//                if let button = subview as? UIButton {
//                    changeButtonAppearance(button, selectedTag)
//                }
//            }
//        }
//    }
    
    
    func setUnselectedState(for tag: Int) {
        print("set unselected")
        if let button = view.viewWithTag(tag) as? UIButton {
            button.backgroundColor = .systemGray5
            button.tintColor = UIColor(named: "mal_color")
        }
    }
    
    func setSelectedState(for tag: Int) {
        print("set selected")
        if let button = view.viewWithTag(tag) as? UIButton {
            button.backgroundColor = UIColor(named: "mal_color")
            button.tintColor = .white
        }
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        viewModel.buttonSelected(sender: sender)
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        viewModel.saveButtonClicked()
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        viewModel.cancelButtonClicked()
    }
    
    
}
