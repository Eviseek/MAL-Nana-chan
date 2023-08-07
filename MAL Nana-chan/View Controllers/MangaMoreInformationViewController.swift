//
//  MangaMoreInformationViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 07.08.2023.
//

import UIKit

class MangaMoreInformationViewController: UIViewController {
    
    @IBOutlet weak var authorsTextView: UITextView!
    @IBOutlet weak var serializationsTextView: UITextView!
    @IBOutlet weak var demographicsTextView: UITextView!
    
    private let viewModel = MangaMoreInformationViewModel()
    
    var id: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = id else { return }
        
        setUpTextViews()
        viewModel.viewDidLoad(vc: self, id: id)
    }
    
    private func setUpTextViews() {
        authorsTextView.isUserInteractionEnabled = true
        authorsTextView.isEditable = false
        authorsTextView.linkTextAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        serializationsTextView.isUserInteractionEnabled = true
        serializationsTextView.isEditable = false
        serializationsTextView.linkTextAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        demographicsTextView.isUserInteractionEnabled = true
        demographicsTextView.isEditable = false
        demographicsTextView.linkTextAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    func setUpUIWith(_ information: MangaInformation) {
        
        if let objects = information.authors {
            authorsTextView.attributedText = getAttributedText(objects: objects)
        }
        
        if let objects = information.serializations {
            serializationsTextView.attributedText = getAttributedText(objects: objects)
        }
        
        if let objects = information.demographics {
            demographicsTextView.attributedText = getAttributedText(objects: objects)
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
