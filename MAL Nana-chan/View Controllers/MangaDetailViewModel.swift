//
//  MangaDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 16.07.2023.
//

import Foundation
import Alamofire

class MangaDetailViewModel {
    
    private var vc: MangaDetailViewController?
    private var id: Int?
    private var manga: Manga?
    private var indicator = ActivityIndicator()
    
    init() {}
    
    func viewDidLoad(vc: MangaDetailViewController, id: Int) {
        self.vc = vc
        self.id = id
        indicator.startAnimating(view: vc.view)
        fetchManga()
    }
    
    private func fetchManga() {
        guard let id = id else { return }
        DataDownloader.dataDownloader.fetchData(URLs.mangaURLAll.rawValue.getURLWithId(id)) { (manga: Manga?, error: AFError?) in
            if let manga = manga {
                print("my manga is \(manga)")
                self.manga = manga
                self.vc?.updateViewWith(manga)
            } else {
                //TODO: show error
            }
            self.indicator.stopAnimating()
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
    
    func seeMoreInfoButtonClicked() {
        if let controller = vc?.storyboard?.instantiateViewController(withIdentifier: "MangaMoreInformationViewController") as? MangaMoreInformationViewController {
            controller.id = manga?.id
            vc?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
