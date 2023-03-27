//
//  Manga.swift
//  MAL Nana-chan
//
//  Created by iOS dev on 25.03.2023.
//

import Foundation

struct Manga: Codable {
    
    var id: Int
    var title: String
    var main_picture: Picture?
    var alternative_titles: AlternativeTitles?
    var start_date: String?
    var end_date: String?
    var synopsis: String?
    var mean: Float? //score
    var rank: Int?
    var popularity: Int?
    var num_list_users: Int?
    var num_scoring_users: Int?
    var nsfw: NSFWValue?
    var genres: [Genre]?
    var created_at: String?
    var updated_at: String?
    var media_type: MangaMediaType? 
    var status: MangaStatus?
    var my_list_status: MyListStatus? //CHANGE
    var num_volumes: Int?
    var num_chapters: Int?
    var authors: [PersonRoleEdge]?
    var related_anime: [RelatedAnimeEdge]? //can get only from detail call
    var related_manga: [RelatedMangaEdge]? //can get only from detail call
   // var recommendations: [Node<T>]? //can get only from detail call
    
}



struct PersonRoleEdge: Codable {
    var node: PersonBase?
    var role: String?
}

struct PersonBase: Codable {
    var id: Int?
    var first_name: String?
    var last_name: String?
}


struct RelatedAnimeEdge: Codable {
    var node: Anime?
   // var relation_type: String?
    var relation_type_formatted: String?
}


struct RelatedMangaEdge: Codable {
    var node: Manga?
    var relation_type_formatted: String?
}




