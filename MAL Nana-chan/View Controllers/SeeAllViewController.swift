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
    
    var sectionContent: Section? = nil
    private var seeAllVM: seeAllViewModel? = nil
    private var items: [Anime]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let sectionContent else {
            //do something?
            return
        }
        
        seeAllVM = seeAllViewModel(viewController: self, content: sectionContent)
        
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
    }
    
}


extension SeeAllViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of items is \(sectionContent?.items.count)")
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as? ItemListTableViewCell {
            var item = items?[indexPath.row]
            cell.titleLabel.text = item?.title
            cell.typeLabel.text = item?.media_type?.rawValue
            cell.episodesTitleLabel.text = item?.num_episodes?.description ?? "?"
            cell.seasonLabel.text = "Season unavailable"
            if let seasonText = item?.start_season?.season, let yearText = item?.start_season?.year { //unwrapping before passing to label
                cell.seasonLabel.text = "\(seasonText) \(yearText)"
            }
            if let url = URL(string: item?.main_picture?.medium ?? "") { //downloading the image from net
                cell.itemImageView.af.setImage(withURL: url)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
}
