//
//  SeeAllViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.06.2023.
//

import UIKit
import AlamofireImage

//TODO: loading!

class SeeAllViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionContent: Section<Anime>? = nil
    private var viewModel: seeAllViewModel? = nil
    private var items: [Anime]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let sectionContent else {
            //do something?
            return
        }
        
        viewModel = seeAllViewModel(viewController: self, content: sectionContent)
        
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


extension SeeAllViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of items is \(sectionContent?.items.count)")
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as? ItemListTableViewCell {
            var item = items?[indexPath.row]
            cell.item = item
            cell.vc = self
            cell.selectionStyle = .none
            cell.titleLabel.text = item?.title
            cell.typeLabel.text = item?.mediaType?.getType()
            if let episodes = item?.episodesCount, episodes > 0 {
                cell.episodesTitleLabel.text = episodes.description
            } else {
                cell.episodesTitleLabel.text = "N/A"
            }
            cell.seasonLabel.text = "Season unavailable"
            cell.scoreLabel.text = item?.score?.description ?? "N/A"
            if let seasonText = item?.startSeason?.season.stringValue(), let yearText = item?.startSeason?.year { //unwrapping before passing to label
                cell.seasonLabel.text = "\(seasonText) \(yearText)"
            }
            if let url = URL(string: item?.mainPicture?.medium ?? "") { //downloading the image from net
                cell.itemImageView.af.setImage(withURL: url)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected!!!")
        viewModel?.itemSelectedAt(indexPath.row)
    }
    
    
    
}
