//
//  MangaPreviewTableViewCell.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.07.2023.
//

import UIKit

class MangaPreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var mangaImageView: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var chaptersNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chaptersTextLabel: UILabel!
    
    @IBOutlet weak var typeContainerView: UIView!
    
    @IBOutlet weak var myListView: UIView!
    @IBOutlet weak var myListButton: UIButton!
    
    var manga: Manga? = nil
    var vc: UIViewController? = nil
    
    private var mainStoryboard = UIStoryboard()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        typeContainerView.layer.cornerRadius = 5
        
        myListView.layer.cornerRadius = 5
        myListView.layer.borderWidth = 1
        myListView.layer.borderColor = UIColor(named: "mal_color")?.cgColor
        
        if !TokenHandler.isUserLoggedIn {
            myListView.isHidden = true
        }
        
    }
    
    func updateChaptersLabel(number: Int) {
        if number == 1 {
            chaptersTextLabel.text = "chapter"
        } else {
            chaptersTextLabel.text = "chapters"
        }
    }
    
    @IBAction func myListClicked(_ sender: UIButton) {
        if let picker = mainStoryboard.instantiateViewController(withIdentifier: "MyMangaStatusViewController") as? MyMangaStatusViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            picker.manga = manga
       //     picker.fromMangalist = false
            vc?.present(picker, animated: true)
        }
    }
}
