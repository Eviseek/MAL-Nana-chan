//
//  AnimelistViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit
import AlamofireImage

class AnimelistViewController: UIViewController {
    
    @IBOutlet weak var notLoggedView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingOverlay: UIView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    
    private var viewModel = AnimelistViewModel()
    private var data: [AnimelistData]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableview()
        viewModel.viewDidLoad(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.viewWillAppear()
    }
    
    
    private func setUpTableview() {
        let nib = UINib(nibName: "AnimelistItemTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "AnimelistItemTableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
        
        //testing only
        let colNib = UINib(nibName: "AnimelistControlCollectionViewCell", bundle: nil)
        collectionview.register(colNib, forCellWithReuseIdentifier: "AnimelistControlCollectionViewCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        
    }
    
    func updateTableViewWith(_ list: [AnimelistData]?) {
        if list == nil {
            //TODO: show info about empty list
        } else {
            print("RELOAD")
            print("data are \(data)")
            self.data = list
            tableview.reloadData()
        }
    }
    
    func updateCollectionView() {
        collectionview.reloadData()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        viewModel.loginButtonClicked()
    }
    
}

extension AnimelistViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getAvailableStatuses().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimelistControlCollectionViewCell", for: indexPath) as? AnimelistControlCollectionViewCell {
            let status = viewModel.getAvailableStatuses()[indexPath.item]
            cell.statusLabel.text = status.name
            if status.isSelected {
                print("cell selected at \(indexPath.item)")
                cell.statusLabel.font = UIFont.systemFont(ofSize: cell.statusLabel.font.pointSize, weight: .bold)
                cell.selectedLineView.isHidden = false
                let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
                if !(visibleRect.contains(cell.frame)) {
                    //TODO
                }
            } else {
                cell.statusLabel.font = UIFont.systemFont(ofSize: cell.statusLabel.font.pointSize, weight: .regular)
                cell.selectedLineView.isHidden = true
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("view clicked")
        viewModel.cellSelected(index: indexPath.item)
        //TODO: show another view
        
    }
    //TODO: dodelat collection view flow layout - roztahnout cell, pridat animaci
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("dlow layout del")
        return collectionView.bounds.size
    }
    
    
}

extension AnimelistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AnimelistItemTableViewCell") as? AnimelistItemTableViewCell {
            let item = data?[indexPath.row].node
            cell.itemTitleLabel.text = item?.title
            cell.itemScoreLabel.text = item?.score?.description
            cell.itemTypeLabel.text = item?.mediaType?.getType()
            if let season = item?.startSeason?.season.stringValue(), let year = item?.startSeason?.year {
                cell.itemSeasonLabel.text = ("\(season) \(year.description)")
            }
            if let url = URL(string: item?.mainPicture?.medium ?? "") {
                cell.itemImageView.af.setImage(withURL: url)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableViewItemSelectedAt(indexPath.row)
    }
    
    
    
    
}
