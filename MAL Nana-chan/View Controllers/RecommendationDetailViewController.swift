//
//  RecommendationDetailViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 29.06.2023.
//

import UIKit
import AlamofireImage

class RecommendationDetailViewController: UIViewController {
    
    //left recommendation outlets
    @IBOutlet weak var leftRecImageView: UIImageView!
    @IBOutlet weak var leftRecTitleLabel: UILabel!
    @IBOutlet weak var leftRecScoreLabel: UILabel!
    @IBOutlet weak var leftRecTypeLabel: UILabel!
    
    //right recommendation outlets
    @IBOutlet weak var rightRecImageView: UIImageView!
    @IBOutlet weak var rightRecTitleLabel: UILabel!
    @IBOutlet weak var rightRecScoreLabel: UILabel!
    @IBOutlet weak var rightRecTypeLabel: UILabel!
    
    @IBOutlet weak var recTextView: UITextView!
    
    var recommendation: RecommendationData? = nil
    
    private var viewModel = RecommendationDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let recommendation = recommendation else { return }
        
        viewModel.ViewDidLoad(detailVC: self)
        
        setUpView(with: recommendation)
        
    }
    
    private func setUpView(with recommendation: RecommendationData) {
        let leftRec = recommendation.entry[0]
        let rightRec = recommendation.entry[1]
        
        if let url = URL(string: leftRec.images.jpg.imageUrl) {
            leftRecImageView.af.setImage(withURL: url)
        }
        leftRecTitleLabel.text = leftRec.title
        //TODO: should i fetch also type and score?
        
        if let url = URL(string: rightRec.images.jpg.imageUrl) {
            rightRecImageView.af.setImage(withURL: url)
        }
        rightRecTitleLabel.text = rightRec.title
        
        recTextView.text = recommendation.content
        
    }
    
    @IBAction func leftRecSelected(_ sender: UIButton) {
        viewModel.recommendationSelected(id: recommendation?.entry[0].id)
    }
    
    @IBAction func rightRecSeletec(_ sender: UIButton) {
        viewModel.recommendationSelected(id: recommendation?.entry[1].id)
    }
    
}
