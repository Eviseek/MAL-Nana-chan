//
//  Strings.swift
//  MAL Nana-chan
//

import Foundation

/// Every piece of copy the user can read.
enum Strings {

    enum Common {
        static let unknown = "Unknown"
        static let notAvailable = "N/A"
        static let notSpecified = "Not specified."
        static let noDescription = "No description."
        static let somethingWentWrong = "Something went wrong."
        static let dismiss = "Dismiss"
        static let okay = "Okay"
        static let error = "Error"
        static let none = "None"
    }

    enum Home {
        static let currentSeason = "This season anime"
        static let upcomingSeason = "Upcoming season anime"
        static let popularAnime = "Popular anime"
    }

    enum Explore {
        static let popularManga = "Popular manga"
        static let queryTooShort = "Query must have at least 3 characters."
    }

    enum Detail {
        static let noSynopsis = "No synopsis"
        static let seeMore = "See more"
        static let seeLess = "See less"
        static let unknownSeason = "Unknown season"
        static let seasonUnavailable = "Season unavailable"
        static let episode = "episode"
        static let episodes = "episodes"
        static let chapter = "chapter"
        static let chapters = "chapters"
    }

    enum Themes {
        static let unavailable = "Theme songs are temporarily unavailable."
    }

    enum MyList {
        static let add = "Add"
        static let save = "Save"
        static let saveFailed = "Couldn't save your list changes. Please try again."
        static let removeFailed = "Couldn't remove this from your list. Please try again."
    }

    enum Animelist {
        static let empty = "Nothing here yet."
        static let all = "All"
    }

    enum Network {
        static let offline = "You appear to be offline."
        static let unauthorized = "Your session expired. Please sign in again."
        static let alreadyUpToDate = "Already up to date."
    }
}
