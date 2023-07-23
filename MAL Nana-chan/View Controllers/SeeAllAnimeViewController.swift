//
//  SeeAllViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.06.2023.
//

import UIKit
import AlamofireImage

//TODO: loading!

class SeeAllAnimeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var animeSectionContent: Section<Anime>? = nil

    private var viewModel = SeeAllAnimeModel()
    private var items = [Anime]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let animeSectionContent else {
            self.showErrorDialog(message: "Something went wrong")
            return
        }
        viewModel.viewDidLoad(viewController: self, content: animeSectionContent)
        tableViewSetUp()
    }
    
    func fillTableView(items: [Anime], completion: @escaping () -> Void) {
        self.items = items
        tableView.reloadData()
        completion()
    }
    
    private func tableViewSetUp() {
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ItemListTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}


extension SeeAllAnimeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("number of items is \(sectionContent?.items.count)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AnimePreviewTableViewCell") as? AnimePreviewTableViewCell {
            var anime = items[indexPath.row]
            cell.item = anime
            cell.vc = self
            cell.selectionStyle = .none
            cell.titleLabel.text = anime.title
            cell.typeLabel.text = anime.mediaType?.getType()
            if let episodes = anime.episodesCount, episodes > 0 {
                cell.episodesTitleLabel.text = episodes.description
            } else {
                cell.episodesTitleLabel.text = "N/A"
            }
            cell.seasonLabel.text = "Season unavailable"
            cell.scoreLabel.text = anime.score?.description ?? "N/A"
            if let seasonText = anime.startSeason?.season.stringValue(), let yearText = anime.startSeason?.year { //unwrapping before passing to label
                cell.seasonLabel.text = "\(seasonText) \(yearText)"
            }
            if let url = URL(string: anime.mainPicture?.medium ?? "") { //downloading the image from net
                cell.itemImageView.af.setImage(withURL: url)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected!!!")
        viewModel.itemSelectedAt(indexPath.row)
    }
    
    
    
}
