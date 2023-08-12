//
//  MyMangaStatusViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.07.2023.
//

import UIKit

class MyMangaStatusViewController: UIViewController {
    
    //UI buttons
    @IBOutlet weak var readingButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var onHoldButton: UIButton!
    @IBOutlet weak var planToReadButton: UIButton!
    @IBOutlet weak var droppedButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var removeFromListButton: UIButton!
    
    //UIViews and stackViews
    @IBOutlet weak var statusContentView: UIView!
    @IBOutlet weak var moreAndRemoveView: UIStackView!
    
    //UI labels
    @IBOutlet weak var mangaTitleLabel: UILabel!
    @IBOutlet weak var mangaStatusLabel: UILabel!
    @IBOutlet weak var myStatusLabel: UILabel!
    @IBOutlet weak var mangaChaptersNumLabel: UILabel!
    @IBOutlet weak var mangaVolumesNumLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    //UI ProgressViews
    @IBOutlet weak var chaptersProgressView: UIProgressView!
    @IBOutlet weak var volumesProgressView: UIProgressView!
    
    @IBOutlet weak var scoreSlider: UISlider!
    
    //UI PickerViews
    @IBOutlet weak var priorityPickerView: UIPickerView!
    
    private let manager = UserMangaStatusManager()
    private let viewModel = MyMangaStatusModel()
    private let priorityManager = PriorityManager()
    private let priorityList: [Priority] = [.low, .medium, .high]
    
    var manga: Manga?
    var fromMangalist: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let manga = manga else {
            self.showErrorDialog(message: "Something went wrong.")
            return
        }
        
        setUpUIView()
        viewModel.viewDidLoad(vc: self, manga: manga)
    }
    
    private func setUpUIView() {
        planToReadButton.layer.cornerRadius = 5
        completedButton.layer.cornerRadius = 5
        onHoldButton.layer.cornerRadius = 5
        readingButton.layer.cornerRadius = 5
        droppedButton.layer.cornerRadius = 5
        removeFromListButton.layer.cornerRadius = 5
        moreDetailsButton.layer.cornerRadius = 5
        setUpButtonTags()
        
        scoreSlider.minimumValue = 0
        scoreSlider.maximumValue = 10
        
        priorityPickerView.dataSource = self
        priorityPickerView.delegate = self
        
        moreDetailsButton.removeFromSuperview()
        
//        if !(fromMangalist ?? false) {
//            moreAndRemoveView.removeFromSuperview()
//        }
    }
    
    private func setUpButtonTags() {
        //print("set up buttons tags")
        planToReadButton.tag = manager.getTagForStatus(.planToRead)
        //print("tag for status plan to watch: \(manager.getTagForStatus(.planToRead))")
        completedButton.tag = manager.getTagForStatus(.completed)
        onHoldButton.tag = manager.getTagForStatus(.onHold)
        readingButton.tag = manager.getTagForStatus(.reading)
        droppedButton.tag = manager.getTagForStatus(.dropped)
    }
    
    func setUIWith(_ manga: Manga) {
        mangaTitleLabel.text = manga.title
        mangaStatusLabel.text = manga.status?.getStatus()
        mangaChaptersNumLabel.text = manga.myListStatus?.chaptersReadCount?.description
        mangaVolumesNumLabel.text = manga.myListStatus?.volumesReadCount?.description ?? "0"
        myStatusLabel.text = manga.myListStatus?.status.getStringValue() ?? "?"
        priorityLabel.text = manga.myListStatus?.priority?.getPriorityString() ?? "Low"
        
        scoreSlider.value = Float(manga.myListStatus?.score ?? 0)
        scoreLabel.text = manga.myListStatus?.score.description ?? "0"
        
        //setting up progress bars
        if let chaptersRead = manga.myListStatus?.chaptersReadCount, chaptersRead > 0 {
            if let chaptersTotal = manga.chaptersCount, chaptersTotal == 0 {
                chaptersProgressView.setProgress(0.5, animated: false)
            } else if let chaptersTotal = manga.chaptersCount {
                let progress = Float(chaptersRead/chaptersTotal)
                chaptersProgressView.setProgress(progress, animated: false)
            }
        } else {
            chaptersProgressView.setProgress(0, animated: false)
        }
        
        if let volumesRead = manga.myListStatus?.volumesReadCount, volumesRead > 0 {
            if let volumesTotal = manga.volumesCount, volumesTotal == 0 {
                chaptersProgressView.setProgress(0.5, animated: false)
            } else if let volumesTotal = manga.volumesCount {
                let progress = Float(volumesRead/volumesTotal)
                volumesProgressView.setProgress(progress, animated: false)
            }
        } else {
            volumesProgressView.setProgress(0, animated: false)
        }
        
        if manga.myListStatus == nil {
            saveButton.setTitle("Add", for: .normal)
            mangaChaptersNumLabel.text = "0"
            mangaVolumesNumLabel.text = "0"
            scoreLabel.text = "0"
            priorityLabel.text = "None"
            myStatusLabel.text = "None"
            moreAndRemoveView.removeFromSuperview()
        }
    }
    
    func setUnselectedState(for tag: Int) {
        //print("set unselected")
        if let button = view.viewWithTag(tag) as? UIButton {
            button.backgroundColor = .systemGray5
            button.tintColor = UIColor(named: "mal_color")
        }
    }
    
    func setSelectedState(for tag: Int) {
        //print("set selected")
        if let button = view.viewWithTag(tag) as? UIButton {
            button.backgroundColor = UIColor(named: "mal_color")
            button.tintColor = .white
        }
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        viewModel.buttonSelected(sender: sender)
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        //print("save clicked")
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
    
    @IBAction func scoreSliderChanged(_ sender: UISlider) {
        scoreLabel.text = Int(scoreSlider.value).description
    }
    
    
}

extension MyMangaStatusViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorityList[row].getPriorityString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityLabel.text = priorityList[row].getPriorityString()
        viewModel.pickerViewChanged(priorityList[row])
    }
    
    
}

