//
//  SearchResultsViewController.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 19.03.2023.
//

import Foundation
import UIKit
import AlamofireImage

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var animeResultsTableView: UITableView!
    @IBOutlet weak var mangaResultsTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var query: String?
    private var viewModel = SearchResultsViewModel()
    private var selectedType: ItemType = .anime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        viewModel.viewDidLoad(viewController: self)
        
        searchBar.text = query
        searchBar.delegate = self
        
    }
    
    private func setUpUI() {
        let nib = UINib(nibName: Identifiers.animePreviewTVCell.rawValue, bundle: nil)
        animeResultsTableView.register(nib, forCellReuseIdentifier: Identifiers.animePreviewTVCell.rawValue)
        animeResultsTableView.dataSource = self
        animeResultsTableView.delegate = self
        
        let mangaNib = UINib(nibName: Identifiers.mangaPreviewTVCell.rawValue, bundle: nil)
        mangaResultsTableView.register(mangaNib, forCellReuseIdentifier: Identifiers.mangaPreviewTVCell.rawValue)
        mangaResultsTableView.dataSource = self
        mangaResultsTableView.delegate = self
    }
    
    func updateTableView(_ type: ItemType) {
        if selectedType == .anime {
            animeResultsTableView.isHidden = false
            mangaResultsTableView.isHidden = true
            animeResultsTableView.reloadData()
        } else {
            animeResultsTableView.isHidden = true
            mangaResultsTableView.isHidden = false
            mangaResultsTableView.reloadData()
        }
    }
    
    func setUpErrorView(message: String) {
        self.showErrorDialog(message: message)
        print("ERROR!!!!")
    }
    
    @IBAction func itemTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedType = .anime
        } else {
            //print("!!!!selected type is manga")
            selectedType = .manga
        }
        viewModel.searchButtonClickedFor(selectedType)
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == .anime {
            return viewModel.animeResults?.data.count ?? 0
        } else if selectedType == .manga {
            //print("manga count is \(viewModel.mangaResults?.data.count)")
            return viewModel.mangaResults?.data.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("selected type is \(selectedType)")
        
        if selectedType == .anime {
            //print("inside anime, anime selected")
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AnimePreviewTableViewCell") as? AnimePreviewTableViewCell {
                    let anime = viewModel.animeResults?.data[indexPath.row].node
                    var seasonText = ""
                    cell.vc = self
                    cell.anime = anime
                    cell.selectionStyle = .none
                    cell.titleLabel.text = anime?.title
                    if let season = anime?.startSeason?.season {
                        seasonText = season.stringValue()
                        seasonText += " "
                    }
                    if let year = anime?.startSeason?.year {
                        seasonText += year.description
                    }
                    cell.seasonLabel.text = seasonText
                    if let score = anime?.score {
                        cell.scoreLabel.text = score.description
                    }
                    cell.typeLabel.text = anime?.mediaType?.getType()
                    cell.updateEpisodesLabel(number: anime?.episodesCount ?? 0)
                    if (anime?.episodesCount ?? 0) > 0 {
                        cell.episodesNumberLabel.text = anime?.episodesCount?.description
                    }
                    
                    if let url = URL(string: anime?.mainPicture?.medium ?? "") {
                        cell.itemImageView?.af.setImage(withURL: url)
                    }
                    
                    return cell
                }
            }
            
            if selectedType == .manga {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MangaPreviewTableViewCell") as? MangaPreviewTableViewCell {
                    let manga = viewModel.mangaResults?.data[indexPath.row].node
                    cell.vc = self
                    cell.manga = manga
                    cell.selectionStyle = .none
                    cell.titleLabel.text = manga?.title
                    cell.seasonLabel.text = manga?.startDate?.extractSeason()
                    
                    cell.chaptersNumberLabel.text = manga?.chaptersCount?.description
                    
                    if let score = manga?.score {
                        cell.scoreLabel.text = score.description
                    }
                    cell.typeLabel.text = manga?.mediaType?.getType()
                    
                    if let url = URL(string: manga?.mainPicture?.medium ?? "") {
                        cell.mangaImageView?.af.setImage(withURL: url)
                    }
                    
                    return cell
                }
            }
        
        return UITableViewCell()
    }
    
}

extension SearchResultsViewController: UITableViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        var mytv: UITableView = animeResultsTableView
        if selectedType == .manga {
            mytv = mangaResultsTableView
        }
        if position > (mytv.contentSize.height - 100 - scrollView.frame.height) {
            if !(viewModel.pagingDone) && !(viewModel.loadingInProgress) {
                viewModel.loadMore()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: row selected at
        viewModel.rowSelectedAt(indexPath.row)
    }
}
    
extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query = searchBar.text
        viewModel.searchButtonClickedFor(selectedType)
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.animeResultsTableView.contentOffset.y = 0
        })
    }
    
}
