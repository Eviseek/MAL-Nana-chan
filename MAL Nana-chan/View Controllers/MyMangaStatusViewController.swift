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
    
    @IBOutlet weak var mangaScoreTextField: UITextField!
    
    private let manager = UserMangaStatusManager()
    private let viewModel = MyMangaStatusModel()
    
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
        setLabels(manga!)
        if !(fromMangalist ?? false) {
            moreAndRemoveView.removeFromSuperview()
        }
    }
    
    private func setUpButtonTags() {
        print("set up buttons tags")
        planToReadButton.tag = manager.getTagForStatus(.planToRead)
        print("tag for status plan to watch: \(manager.getTagForStatus(.planToRead))")
        completedButton.tag = manager.getTagForStatus(.completed)
        onHoldButton.tag = manager.getTagForStatus(.onHold)
        readingButton.tag = manager.getTagForStatus(.reading)
        droppedButton.tag = manager.getTagForStatus(.dropped)
    }
    
    private func setLabels(_ manga: Manga) {
        mangaTitleLabel.text = manga.title
        mangaStatusLabel.text = manga.status?.getStatus()
        mangaChaptersNumLabel.text = manga.chaptersCount?.description
        mangaScoreTextField.text = manga.myListStatus?.score.description ?? "0"
        myStatusLabel.text = manga.myListStatus?.status.getStringValue() ?? "?"
        if manga.myListStatus == nil {
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
    
}

