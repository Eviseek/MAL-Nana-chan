//
//  SeeAllViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 23.06.2023.
//

import UIKit
import AlamofireImage


class SeeAllViewController<T: Codable>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    
    var section: Section<T>? = nil

    private var viewModel = SeeAllViewModel<T>()
    private var anime = [Node<Anime>]()
    private var manga = [Node<Manga>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        guard let section else {
            self.showErrorDialog(message: "Something went wrong.")
            return
        }
        
        if T.self == Manga.self {
            mangaTableViewSetUp()
        } else {
            animeTableViewSetUp()
        }
        
        viewModel.viewDidLoad(viewController: self, section: section)
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .white
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func fillTableView(anime: [Node<Anime>]) {
        self.anime.append(contentsOf: anime)
        tableView.reloadData()
    }
    
    func fillTableView(manga: [Node<Manga>]) {
        self.manga.append(contentsOf: manga)
        tableView.reloadData()
    }
    
    private func mangaTableViewSetUp() {
        let nib = UINib(nibName: "MangaPreviewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MangaPreviewTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func animeTableViewSetUp() {
        let nib = UINib(nibName: "AnimePreviewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AnimePreviewTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.section?.type == .anime {
            return anime.count
        }
        
        if self.section?.type == .manga {
            return manga.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.section?.type == .anime {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AnimePreviewTableViewCell") as? AnimePreviewTableViewCell {
                var anime = anime[indexPath.row].node
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
            
        }
        
        if self.section?.type == .manga {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MangaPreviewTableViewCell") as? MangaPreviewTableViewCell {
                var manga = manga[indexPath.row].node
                cell.manga = manga
                cell.vc = self
                cell.selectionStyle = .none
                cell.titleLabel.text = manga.title
                cell.typeLabel.text = manga.mediaType?.getType()
                if let chapters = manga.chaptersCount, chapters > 0 {
                    cell.chaptersNumberLabel.text = chapters.description
                } else {
                    cell.chaptersNumberLabel.text = "N/A"
                }
                cell.seasonLabel.text = "Season unavailable"
                cell.scoreLabel.text = manga.score?.description ?? "N/A"
//                if let seasonText = manga.startSeason?.season.stringValue(), let yearText = manga. { //unwrapping before passing to label
//                    cell.seasonLabel.text = "\(seasonText) \(yearText)"
//                }
                if let url = URL(string: manga.mainPicture?.medium ?? "") { //downloading the image from net
                    cell.mangaImageView.af.setImage(withURL: url)
                }
                return cell
            }
            
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected!!!")
        viewModel.itemSelectedAt(indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100 - scrollView.frame.size.height) && !viewModel.isFetching {
            print("fetch more")
            viewModel.scrolledToBottom()
        }
    }
    
}
