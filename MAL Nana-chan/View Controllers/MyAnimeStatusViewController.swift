//
//  AnimelistDetailViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 30.06.2023.
//

import UIKit

class MyAnimeStatusViewController: UIViewController {
    
    //UI buttons
    @IBOutlet weak var planToWatchButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var onHoldButton: UIButton!
    @IBOutlet weak var watchingButton: UIButton!
    @IBOutlet weak var droppedButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var removeFromListButton: UIButton!
    
    //UIViews and stackViews
    @IBOutlet weak var statusContentView: UIView!
    @IBOutlet weak var moreAndRemoveView: UIStackView!
    
    //UI labels
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemStatusLabel: UILabel!
    @IBOutlet weak var myStatusLabel: UILabel!
    @IBOutlet weak var itemEpisodesNumLabel: UILabel!
    @IBOutlet weak var itemEpisodesWatchedLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var itemScoreLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var scoreSlider: UISlider!
    @IBOutlet weak var priorityPicker: UIPickerView!
    
    private let manager = UserAnimeStatusManager()
    private let viewModel = MyAnimeStatusModel()
    
    var anime: Anime?
    var fromAnimelist: Bool?
    
    private let priorities = ["Low", "Medium", "High"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let anime = anime else { return }
        
        setUpUIView()
  
        viewModel.viewDidLoad(vc: self, anime: anime)
    }
    
    private func setUpUIView() {
        planToWatchButton.layer.cornerRadius = 5
        completedButton.layer.cornerRadius = 5
        onHoldButton.layer.cornerRadius = 5
        watchingButton.layer.cornerRadius = 5
        droppedButton.layer.cornerRadius = 5
        removeFromListButton.layer.cornerRadius = 5
        moreDetailsButton.layer.cornerRadius = 5
        
        priorityPicker.dataSource = self
        priorityPicker.delegate = self
        
        setUpButtonTags()
        setValuesForView(anime!)
        
        if !(fromAnimelist ?? false) {
            moreAndRemoveView.removeFromSuperview()
        }
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
    
    private func setValuesForView(_ anime: Anime) {
        itemTitleLabel.text = anime.title
        itemStatusLabel.text = anime.status?.getStatus()
        
        myStatusLabel.text = anime.myListStatus?.status.getStringValue() ?? "?"
        itemEpisodesWatchedLabel.text = anime.myListStatus?.episodesWatchedCount?.description
        itemEpisodesNumLabel.text = anime.episodesCount?.description
        
        if let episodesTotal = anime.episodesCount, episodesTotal != 0 {
            progressBar.progress = Float(Double(anime.myListStatus?.episodesWatchedCount ?? 0) / Double(episodesTotal))
        } else {
            itemEpisodesNumLabel.text = "N/A"
        }
        
        scoreSlider.minimumValue = 0
        scoreSlider.maximumValue = 10
        scoreSlider.value = Float(anime.myListStatus?.score ?? 0)
        itemScoreLabel.text = anime.myListStatus?.score.description
        
        priorityLabel.text = anime.myListStatus?.priority?.getPriorityString() ?? "Low"
        
        if anime.myListStatus == nil {
            print("my status is nil")
            //TODO: change save button to add
        }
        
    }
    
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
    
    @IBAction func removeClicked(_ sender: UIButton) {
        viewModel.removeButtonClicked()
    }
    
    
    @IBAction func moreDetailsClicked(_ sender: UIButton) {
        viewModel.moreDetailsButtonClicked()
    }
    
    @IBAction func scoreSliderValueChanged(_ sender: UISlider) {
        itemScoreLabel.text = (Int(scoreSlider.value)).description
    }
    
}

extension MyAnimeStatusViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return priorities[row]
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityLabel.text = priorities[row]
    }
    
    
    
    
}
