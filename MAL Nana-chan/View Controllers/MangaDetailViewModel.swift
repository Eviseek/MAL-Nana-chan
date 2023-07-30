//
//  MangaDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 16.07.2023.
//

import Foundation

class MangaDetailViewModel {
    
    private var vc: MangaDetailViewController?
    private var id: Int?
    private var manga: Manga?
    private var indicator = ActivityIndicator()
    
    init() {}
    
    func viewDidLoad(vc: MangaDetailViewController, id: Int) {
        self.vc = vc
        self.id = id
        indicator.startAnimating(view: vc.view, background: nil)
        fetchManga()
    }
    
    private func fetchManga() {
        guard let id = id else { return }
        DataDownloader.dataDownloader.fetchData(URLs.mangaURLAll.rawValue.getURLWithId(id)) { (manga: Manga?) in
            self.manga = manga
            if manga != nil {
                self.vc?.updateViewWith(manga!)
                self.indicator.stopAnimating()
            } else {
                self.vc?.noDataView()
            }
        }
    }
    
    func addToListClicked() {
        if let picker = vc?.storyboard?.instantiateViewController(withIdentifier: "MyMangaStatusViewController") as? MyMangaStatusViewController {
            if let sheet = picker.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            picker.manga = manga
            vc?.present(picker, animated: true)
        }
    }
    
}
