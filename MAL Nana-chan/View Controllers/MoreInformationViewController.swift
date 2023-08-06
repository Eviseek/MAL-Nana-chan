//
//  MoreInformationViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.08.2023.
//

import UIKit

class MoreInformationViewController: UIViewController {
    
    @IBOutlet weak var studiosTextView: UITextView!
    @IBOutlet weak var producersTextView: UITextView!
    @IBOutlet weak var licensorsTextView: UITextView!
    
    @IBOutlet weak var studiosView: UIView!
    @IBOutlet weak var producersView: UIView!
    @IBOutlet weak var licensorsView: UIView!
    
    private let viewModel = MoreInformationViewModel()
    
    var id: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = id else { return }
        
        setUpTextViews()
        viewModel.viewDidLoad(vc: self, id: id)
        
    }
    
    private func setUpTextViews() {
        studiosTextView.isUserInteractionEnabled = true
        studiosTextView.isEditable = false
        studiosTextView.linkTextAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        producersTextView.isUserInteractionEnabled = true
        producersTextView.isEditable = false
        producersTextView.linkTextAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        licensorsTextView.isUserInteractionEnabled = true
        licensorsTextView.isEditable = false
        licensorsTextView.linkTextAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    func setUpUIWith(_ information: Information) {
        
        if let objects = information.studios {
            studiosTextView.attributedText = getAttributedText(objects: objects)
        }
        
        if let objects = information.producers {
            producersTextView.attributedText = getAttributedText(objects: objects)
        }
        
        if let objects = information.licensors {
            licensorsTextView.attributedText = getAttributedText(objects: objects)
        }
        
    }
    
    func showErrorView(message: String) {
        
    }
    
    private func getAttributedText(objects: [JikanObject]) -> NSMutableAttributedString {
        
        var attributedText = NSMutableAttributedString("")
        
        for object in objects {
            if let url = URL(string: object.url) {
                let attributedString = NSMutableAttributedString(string: object.name)
                attributedString.setAttributes([.link: url], range: NSMakeRange(0, object.name.count))
                attributedText.append(attributedString)
                attributedText.append(NSAttributedString(string: ", "))
            }
        }
        
        return attributedText
    }
    
}
