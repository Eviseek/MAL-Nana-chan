//
//  AnimelistViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit

class AnimelistViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableview()
    }
    
    private func setUpTableview() {
        let nib = UINib(nibName: "AnimelistItemTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "AnimelistItemTableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
}

extension AnimelistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AnimelistItemTableViewCell") as? AnimelistItemTableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
}
