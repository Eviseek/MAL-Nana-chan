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
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var emptyListLabel: UILabel!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMsgLabel: UILabel!
    
    
    private var viewModel = AnimelistViewModel()
    private var data: [AnimelistData]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableview()
        viewModel.viewDidLoad(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.viewWillAppear()
    }
    
    private func setUpTableview() {
        let nib = UINib(nibName: "AnimelistItemTableViewCell", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: "AnimelistItemTableViewCell")
        listTableView.dataSource = self
        listTableView.delegate = self
        
        //testing only
        let colNib = UINib(nibName: "AnimelistControlCollectionViewCell", bundle: nil)
        collectionview.register(colNib, forCellWithReuseIdentifier: "AnimelistControlCollectionViewCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        
    }
    
    func setUpErrorView(message: String) {
        errorMsgLabel.text = message
        notLoggedView.isHidden = true
        listTableView.isHidden = true
        errorView.isHidden = false
    }
    
    func updateTableViewWith(_ list: [AnimelistData]?, scrollToTop: Bool) {
        listTableView.isHidden = false

        notLoggedView.isHidden = true
        errorView.isHidden = true
        emptyListLabel.isHidden = true
        
        self.data = list
      //  print("my data are \(data)")
        
        if scrollToTop {
            listTableView.setContentOffset(.zero, animated: true)
        }
        
        listTableView.reloadData()
    }
    
    func setUpEmptyList() {
        errorView.isHidden = true
        notLoggedView.isHidden = true
        listTableView.isHidden = true
        emptyListLabel.isHidden = false
    }
    
    func updateCollectionView() {
        collectionview.reloadData()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        viewModel.loginButtonClicked()
    }
    
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        viewModel.tryAgainButtonClicked()
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
        viewModel.statusSelected(index: indexPath.item)
    }
    
    //TODO: dodelat collection view flow layout - roztahnout cell, pridat animaci
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}

extension AnimelistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("data count is \(data?.count)")
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AnimelistItemTableViewCell") as? AnimelistItemTableViewCell {
            var anime = data?[indexPath.row].node
            anime?.myListStatus = data?[indexPath.row].list_status
            cell.selectionStyle = .none
            cell.anime = anime
            cell.parentVC = self
            cell.itemTitleLabel.text = anime?.title
            cell.itemScoreLabel.text = anime?.score?.description
            cell.itemTypeLabel.text = anime?.mediaType?.getType()
            cell.itemStatusLabel.text = anime?.status?.getStatus()
            if let season = anime?.startSeason?.season.stringValue(), let year = anime?.startSeason?.year {
                cell.itemSeasonLabel.text = ("\(season) \(year.description)")
            }
            if let url = URL(string: anime?.mainPicture?.medium ?? "") {
                cell.itemImageView.af.setImage(withURL: url)
            }
            cell.itemListScoreLabel.text = anime?.myListStatus?.score.description
            cell.itemListStatusLabel.text = anime?.myListStatus?.status.getStringValue()
            cell.itemListPriorityLabel.text = anime?.myListStatus?.priority?.getPriorityString() ?? "Low"
            if let progress = anime?.myListStatus?.episodesWatchedCount?.description {
                print("episode progress is \(progress)")
                cell.itemListProgressLabel.text = ("\(progress)/\(anime?.episodesCount?.description ?? "?")")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableViewItemSelectedAt(indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (listTableView.contentSize.height-50 - scrollView.frame.size.height) && !viewModel.isFetching {
            print("fetch more")
            viewModel.scrolledToBottom()
        } else {
           // print("priiint")
        }
    }
    
    
}
