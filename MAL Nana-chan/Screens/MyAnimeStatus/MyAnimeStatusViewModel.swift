//
//  MyAnimeStatusViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// The editable state of the "my anime list" sheet.
struct MyAnimeStatusContent {
    let title: String
    /// The anime's own airing status.
    let mediaStatusText: String?
    let listStatusText: String
    let episodesWatchedText: String
    let totalEpisodesText: String
    /// 0...1 for the progress bar.
    let progress: Float
    let scoreText: String
    let score: Float
    let priorityText: String
    let selectedStatus: UserAnimeStatus
    /// "Add" for a title that isn't on the list yet, "Save" for one that is.
    let saveButtonTitle: String
    /// Removing only makes sense for something already on the list.
    let canRemove: Bool
}

/// Drives the "add to / edit my anime list" sheet.
final class MyAnimeStatusViewModel {

    private let target: MediaListTarget
    private let animeService: AnimeServicing

    /// The user's edits, held here rather than read back off the labels.
    private var selectedStatus: UserAnimeStatus = .planToWatch
    private var score = 0
    private var episodesWatched = 0
    private var priority: Priority = .low
    private var existingStatus: MyAnimeListStatus?

    let priorities = Priority.allCases

    private(set) var state: ViewState<MyAnimeStatusContent> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<MyAnimeStatusContent>) -> Void)?
    var onShowMessage: ((String) -> Void)?
    var onDismiss: (() -> Void)?
    /// Fires only after a successful save or removal.
    var onListChanged: (() -> Void)?

    init(target: MediaListTarget, animeService: AnimeServicing) {
        self.target = target
        self.animeService = animeService
    }

    func onViewDidLoad() {
        load()
    }

    // MARK: - Editing

    func selectStatus(buttonTag: Int) {
        guard let status = UserAnimeStatus(buttonTag: buttonTag) else { return }
        selectedStatus = status
        publish()
    }

    func setScore(_ newScore: Int) {
        score = newScore
        publish()
    }

    func selectPriority(at index: Int) {
        guard priorities.indices.contains(index) else { return }
        priority = priorities[index]
        publish()
    }

    // MARK: - Saving

    func save() {
        let status = MyAnimeListStatus(
            status: selectedStatus,
            score: score,
            episodesWatchedCount: episodesWatched,
            priority: priority
        )

        animeService.updateListStatus(animeID: target.id, status: status) { [weak self] result in
            self?.handleWrite(result, failureMessage: Strings.MyList.saveFailed)
        }
    }

    func remove() {
        animeService.removeFromList(animeID: target.id) { [weak self] result in
            self?.handleWrite(result, failureMessage: Strings.MyList.removeFailed)
        }
    }

    func cancel() {
        onDismiss?()
    }

    /// Both writes succeed or fail the same way.
    private func handleWrite(_ result: Result<Void, APIError>, failureMessage: String) {
        switch result {
        case .success:
            onListChanged?()
            onDismiss?()
        case .failure(let error):
            onShowMessage?("\(failureMessage)\n\n\(error.userMessage)")
        }
    }

    // MARK: - Loading

    private func load() {
        state = .loading

        animeService.listStatus(animeID: target.id) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let status):
                self.existingStatus = status
                self.applyDefaults(from: status)
                self.publish()
            case .failure(let error):
                self.state = .failure(error.userMessage)
            }
        }
    }

    /// Seeds the editable values from whatever is already on the user's list.
    private func applyDefaults(from status: MyAnimeListStatus?) {
        guard let status else {
            // Not on the list yet: the sheet opens on "plan to watch" with
            // everything zeroed.
            selectedStatus = .planToWatch
            score = 0
            episodesWatched = 0
            priority = .low
            return
        }

        selectedStatus = status.status
        score = status.score
        episodesWatched = status.episodesWatchedCount ?? 0
        priority = status.priority ?? .low
    }

    private func publish() {
        state = .content(MyAnimeStatusContent(
            title: target.title,
            mediaStatusText: target.statusText,
            listStatusText: selectedStatus.displayName,
            episodesWatchedText: episodesWatched.description,
            totalEpisodesText: target.unitCount.map(String.init) ?? Strings.Common.notAvailable,
            progress: progressValue,
            scoreText: score.description,
            score: Float(score),
            priorityText: priority.displayName,
            selectedStatus: selectedStatus,
            saveButtonTitle: existingStatus == nil ? Strings.MyList.add : Strings.MyList.save,
            canRemove: existingStatus != nil
        ))
    }

    /// Watched over total, as a fraction.
    private var progressValue: Float {
        guard let total = target.unitCount, total > 0 else { return 0 }
        return min(Float(episodesWatched) / Float(total), 1)
    }
}
