//
//  MediaSection.swift
//  MAL Nana-chan
//

import Foundation

/// A titled, horizontally scrolling row of posters, plus its paging cursor.
struct MediaSection {
    let title: String
    let kind: ItemType
    var items: [MediaPreview]
    /// MAL's `paging.next`, if there are more pages.
    var nextPageURL: String?
}

extension MediaSection {

    init(title: String, page: MediaPage, kind: ItemType) {
        self.title = title
        self.kind = kind
        self.items = page.items
        self.nextPageURL = page.nextPageURL
    }
}

/// One page of a paginated list.
///
/// Services hand this back instead of `Response<Anime>` / `Response<Manga>`, which
/// is what lets the screens above them stop being generic over the media type.
struct MediaPage {
    var items: [MediaPreview]
    var nextPageURL: String?

    static let empty = MediaPage(items: [], nextPageURL: nil)
}

extension MediaPage {

    init(_ response: Response<Anime>) {
        items = response.data.map(\.preview)
        nextPageURL = response.paging?.next
    }

    init(_ response: Response<Manga>) {
        items = response.data.map(\.preview)
        nextPageURL = response.paging?.next
    }
}
