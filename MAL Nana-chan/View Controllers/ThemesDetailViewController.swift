//
//  ThemesDetailViewController.swift
//  MAL Nana-chan
//
//  Created by Eva Chlpikova on 06.08.2023.
//

import UIKit

class ThemesDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var id: Int? = nil
    private var viewModel = ThemesDetailViewModel()
    private var themes = Themes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = id else {
            setUpErrorView(message: "-")
            return
        }
        
        setUpUI()
        viewModel.viewDidLoad(vc: self, id: id)
    }
    
    private func setUpUI() {
        let nib = UINib(nibName: "ThemeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ThemeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fillTableViewWith(_ themes: Themes) {
        self.themes = themes
        errorView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func setUpErrorView(message: String?) {
        errorMsgLabel.text = message
        errorView.isHidden = false
        tableView.isHidden = true
    }
    
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        viewModel.tryAgainButtonClicked()
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
}

extension ThemesDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return themes.openings?.count ?? 0
        } else {
            return themes.endings?.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTableViewCell") as? ThemeTableViewCell {
            var selectedThemes: [String]?
            if segmentedControl.selectedSegmentIndex == 0 {
                selectedThemes = themes.openings
            } else {
                selectedThemes = themes.endings
            }
            cell.selectionStyle = .none
            cell.themeTitleLabel.text = selectedThemes?[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var theme: String = ""
        
        if segmentedControl.selectedSegmentIndex == 0 {
            theme = themes.openings?[indexPath.row] ?? ""
        } else {
            theme = themes.endings?[indexPath.row] ?? ""
        }
        
        var url = "https://www.youtube.com/results?search_query={query}"
        let encodedPart = theme.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        url = url.replacingOccurrences(of: "{query}", with: encodedPart ?? "")
        print("my url is \(url)")
        

        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
}
