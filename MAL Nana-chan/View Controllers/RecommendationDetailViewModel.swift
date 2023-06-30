//
//  RecommendationDetailViewModel.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 30.06.2023.
//

import Foundation

class RecommendationDetailViewModel {
    
    private var detailVC: RecommendationDetailViewController?
    
    func ViewDidLoad(detailVC: RecommendationDetailViewController) {
        self.detailVC = detailVC
    }
    
    func recommendationSelected(id: Int?) {
        if let id = id, let controller = detailVC?.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
            controller.id = id
            detailVC?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
