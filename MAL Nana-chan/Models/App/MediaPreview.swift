//
//  MediaPreview.swift
//  MAL Nana-chan
//

import Foundation

/// One anime or manga, reduced to exactly what a list row or poster tile shows.
struct MediaPreview: Hashable {

    let id: Int
    let kind: ItemType
    let title: String
    let imageURL: String?
    let score: Float?

    /// Broadcast season for anime, start date for manga.
    let seasonText: String?
    let typeText: String?
    let statusText: String?

    /// Episodes for anime, chapters for manga.
    let unitCount: Int?
    /// Volumes. Manga only, `nil` for anime.
    let volumeCount: Int?

    /// "Sequel", "Side story"… set only when this item came from a related list.
    var relationText: String?

    /// Whether the signed-in user already has this on their list, when the
    /// response told us.
    var isOnUserList: Bool = false
}

extension MediaPreview {

    var scoreText: String {
        guard let score else { return Strings.Common.notAvailable }
        return score.description
    }

    var unitCountText: String {
        guard let unitCount, unitCount > 0 else { return Strings.Common.notAvailable }
        return unitCount.description
    }

    /// "episode"/"episodes" or "chapter"/"chapters", agreeing with `unitCount`.
    var unitName: String {
        switch kind {
        case .anime:
            return unitCount == 1 ? Strings.Detail.episode : Strings.Detail.episodes
        case .manga:
            return unitCount == 1 ? Strings.Detail.chapter : Strings.Detail.chapters
        }
    }

    /// What the "my list" sheet needs to open for this item.
    var listTarget: MediaListTarget {
        MediaListTarget(
            id: id,
            kind: kind,
            title: title,
            statusText: statusText,
            unitCount: unitCount,
            volumeCount: volumeCount
        )
    }
}

// MARK: - Mapping from the API models

extension Anime {

    var preview: MediaPreview {
        MediaPreview(
            id: id,
            kind: .anime,
            title: title,
            imageURL: mainPicture?.medium,
            score: score,
            seasonText: startSeason?.displayName ?? Strings.Detail.seasonUnavailable,
            typeText: mediaType?.displayName,
            statusText: status?.displayName,
            unitCount: episodesCount,
            volumeCount: nil,
            isOnUserList: myListStatus != nil
        )
    }
}

extension Manga {

    var preview: MediaPreview {
        MediaPreview(
            id: id,
            kind: .manga,
            title: title,
            imageURL: mainPicture?.medium,
            score: score,
            seasonText: startDate?.season() ?? Strings.Detail.seasonUnavailable,
            typeText: mediaType?.displayName,
            statusText: status?.displayName,
            unitCount: chaptersCount,
            volumeCount: volumesCount,
            isOnUserList: myListStatus != nil
        )
    }
}

extension Node where Value == Anime {

    /// A preview that carries the relation label MAL attached to the node.
    var preview: MediaPreview {
        var preview = node.preview
        preview.relationText = relationTypeFormatted
        return preview
    }
}

extension Node where Value == Manga {

    var preview: MediaPreview {
        var preview = node.preview
        preview.relationText = relationTypeFormatted
        return preview
    }
}
