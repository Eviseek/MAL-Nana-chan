//
//  MyMangaStatusViewModel.swift
//  MAL Nana-chan
//

import Foundation

/// The editable state of the "my manga list" sheet.
struct MyMangaStatusContent {
    let title: String
    let mediaStatusText: String?
    let listStatusText: String
    let chaptersReadText: String
    let volumesReadText: String
    let chaptersProgress: Float
    let volumesProgress: Float
    let scoreText: String
    let score: Float
    let priorityText: String
    let selectedStatus: UserMangaStatus
    let saveButtonTitle: String
    let canRemove: Bool
}

/// Drives the "add to / edit my manga list" sheet. Mirrors
/// `MyAnimeStatusViewModel`, with volumes as well as chapters.
final class MyMangaStatusViewModel {

    private let target: MediaListTarget
    private let mangaService: MangaServicing

    private var selectedStatus: UserMangaStatus = .planToRead
    private var score = 0
    private var chaptersRead = 0
    private var volumesRead = 0
    private var priority: Priority = .low
    private var existingStatus: MyMangaListStatus?

    let priorities = Priority.allCases

    private(set) var state: ViewState<MyMangaStatusContent> = .loading {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ViewState<MyMangaStatusContent>) -> Void)?
    var onShowMessage: ((String) -> Void)?
    var onDismiss: (() -> Void)?
    var onListChanged: (() -> Void)?

    init(target: MediaListTarget, mangaService: MangaServicing) {
        self.target = target
        self.mangaService = mangaService
    }

    func onViewDidLoad() {
        load()
    }

    // MARK: - Editing

    func selectStatus(buttonTag: Int) {
        guard let status = UserMangaStatus(buttonTag: buttonTag) else { return }
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
        let status = MyMangaListStatus(
            status: selectedStatus,
            score: score,
            volumesReadCount: volumesRead,
            chaptersReadCount: chaptersRead,
            priority: priority
        )

        mangaService.updateListStatus(mangaID: target.id, status: status) { [weak self] result in
            self?.handleWrite(result, failureMessage: Strings.MyList.saveFailed)
        }
    }

    func remove() {
        mangaService.removeFromList(mangaID: target.id) { [weak self] result in
            self?.handleWrite(result, failureMessage: Strings.MyList.removeFailed)
        }
    }

    func cancel() {
        onDismiss?()
    }

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

        mangaService.listStatus(mangaID: target.id) { [weak self] result in
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

    private func applyDefaults(from status: MyMangaListStatus?) {
        guard let status else {
            selectedStatus = .planToRead
            score = 0
            chaptersRead = 0
            volumesRead = 0
            priority = .low
            return
        }

        selectedStatus = status.status
        score = status.score
        chaptersRead = status.chaptersReadCount ?? 0
        volumesRead = status.volumesReadCount ?? 0
        priority = status.priority ?? .low
    }

    private func publish() {
        state = .content(MyMangaStatusContent(
            title: target.title,
            mediaStatusText: target.statusText,
            listStatusText: selectedStatus.displayName,
            chaptersReadText: chaptersRead.description,
            volumesReadText: volumesRead.description,
            chaptersProgress: Self.progress(read: chaptersRead, total: target.unitCount),
            volumesProgress: Self.progress(read: volumesRead, total: target.volumeCount),
            scoreText: score.description,
            score: Float(score),
            priorityText: priority.displayName,
            selectedStatus: selectedStatus,
            saveButtonTitle: existingStatus == nil ? Strings.MyList.add : Strings.MyList.save,
            canRemove: existingStatus != nil
        ))
    }

    /// Read over total, as a fraction.
    private static func progress(read: Int, total: Int?) -> Float {
        guard read > 0 else { return 0 }
        guard let total, total > 0 else { return 0.5 }
        return min(Float(read) / Float(total), 1)
    }
}
