//
//  Identifiers.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 04.02.2023.
//

import Foundation

enum Identifiers: String {
    
    // Collection Views
    
    case animeCVCell = "AnimeCollectionViewCell"
    case animeCV = "AnimeCollectionView"
    
    case mangaCVCell = "MangaSectionCollectionViewCell"
    case mangaCV = "MangaCollectionView"
    
    // Table Views
    
    case animeSectionTVCell = "AnimeSectionTableViewCell"
    case animeSectionTV = "AnimeSectionTableView"
    
    case mangaSectionTVCell = "MangaSectionTableViewCell"
    case mangaSectionTV = "MangaSectionTableView"
    
    case YTEmbedTableViewCell = "YoutubeEmbedTableViewCell"
    
    case RSTableViewCell = "RecentSearchesTableViewCell"
    
    case animePreviewTVCell = "AnimePreviewTableViewCell"
    
    case mangaPreviewTVCell = "MangaPreviewTableViewCell"
    
    // User Defaults
    
    case RecentSearches = "recentSearchesArr"
    
    
    case GenreCollectionViewCell
    
    //Keychain
    case keychainToken = "userToken"
    
    //Alamofire header
    case headerAuthID = "X-MAL-CLIENT-ID"
}
