//
//  MangaDetailViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Full details for one manga.
final class MangaDetailViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var infoView: UIView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var pictureImageView: UIImageView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var volumesLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var chaptersLabel: UILabel!

    @IBOutlet private weak var synopsisTextView: UITextView!
    @IBOutlet private weak var seeMoreButton: UIButton!

    @IBOutlet private weak var synonymsLabel: UILabel!
    @IBOutlet private weak var enSynonymsLabel: UILabel!
    @IBOutlet private weak var jpSynonymsLabel: UILabel!

    @IBOutlet private weak var genresCollectionView: UICollectionView!
    @IBOutlet private weak var relatedAnimeCollectionView: UICollectionView!
    @IBOutlet private weak var relatedMangaCollectionView: UICollectionView!
    @IBOutlet private weak var recommendationsCollectionView: UICollectionView!

    @IBOutlet private weak var relatedAnimeContainerView: UIView!
    @IBOutlet private weak var relatedMangaContainerView: UIView!
    @IBOutlet private weak var recommendationsContainerView: UIView!

    @IBOutlet private weak var genresCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var relatedAnimeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var relatedMangaCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var recommendationsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var synopsisTextViewHeight: NSLayoutConstraint!

    @IBOutlet private weak var addToListButton: UIButton!

    // MARK: State

    var viewModel: MangaDetailViewModel!
    var coordinator: MediaCoordinator?

    private let loadingIndicator = LoadingIndicator()
    private var content: MangaDetailContent?
    private var expandedSynopsisHeight = Layout.collapsedSynopsisHeight

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        bindViewModel()
        viewModel.onViewDidLoad()
    }

    // MARK: - Set-up

    private func setUpViews() {
        infoView.round()
        addToListButton.isHidden = !viewModel.isSignedIn

        genresCollectionView.register(GenreCollectionViewCell.self)
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self

        for strip in mediaCollectionViews {
            strip.register(AnimeCollectionViewCell.self)
            strip.register(MangaCollectionViewCell.self)
            strip.dataSource = self
            strip.delegate = self
        }

        relatedAnimeCollectionViewHeight.constant = Layout.MediaCell.height
        relatedMangaCollectionViewHeight.constant = Layout.MediaCell.height
        recommendationsCollectionViewHeight.constant = Layout.MediaCell.height

        // The three strips start hidden and are revealed by `applyStrips` once we
        // know whether MAL sent anything for them. The old screen called
        // `removeFromSuperview()` on all three unconditionally in set-up, which
        // deleted the related and recommended sections from the manga screen
        // outright — the data was being fetched and then thrown away.
        setStripsHidden(true)
    }

    private var mediaCollectionViews: [UICollectionView] {
        [relatedAnimeCollectionView, relatedMangaCollectionView, recommendationsCollectionView]
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onOpenMedia = { [weak self] preview in
            self?.coordinator?.showDetail(for: preview)
        }
        viewModel.onOpenCredits = { [weak self] mangaID in
            self?.coordinator?.showMangaCredits(mangaID: mangaID)
        }
        viewModel.onOpenListSheet = { [weak self] target in
            self?.coordinator?.presentListSheet(for: target)
        }
    }

    // MARK: - Rendering

    private func render(_ state: ViewState<MangaDetailContent>) {
        switch state {
        case .loading:
            loadingIndicator.start(in: view)

        case .content(let content):
            loadingIndicator.stop()
            self.content = content
            apply(content)

        case .empty(let message), .failure(let message):
            loadingIndicator.stop()
            content = nil
            // This screen has no error view in the storyboard, so the message goes
            // in an alert instead of being swallowed.
            showErrorDialog(message: message)
        }
    }

    private func apply(_ content: MangaDetailContent) {
        applyHeader(content)
        applySynopsis(content.synopsis)
        applyStrips(content)
    }

    private func applyHeader(_ content: MangaDetailContent) {
        nameLabel.text = content.title
        scoreLabel.text = content.scoreText
        typeLabel.text = content.typeText
        statusLabel.text = content.statusText
        volumesLabel.text = content.volumesText
        chaptersLabel.text = content.chaptersText
        pictureImageView.setRemoteImage(content.imageURL)

        if let synonymsText = content.synonymsText { synonymsLabel.text = synonymsText }
        if let englishTitle = content.englishTitle { enSynonymsLabel.text = englishTitle }
        if let japaneseTitle = content.japaneseTitle { jpSynonymsLabel.text = japaneseTitle }

        genresCollectionView.reloadData()
    }

    private func applySynopsis(_ synopsis: String) {
        synopsisTextView.text = synopsis
        synopsisTextView.sizeToFit()

        expandedSynopsisHeight = synopsisTextView.contentSize.height

        let fitsWithoutExpanding = expandedSynopsisHeight < Layout.collapsedSynopsisHeight
        synopsisTextViewHeight.constant = fitsWithoutExpanding
            ? expandedSynopsisHeight
            : Layout.collapsedSynopsisHeight
        seeMoreButton.isHidden = fitsWithoutExpanding
        setSeeMoreTitle(isExpanded: false)
    }

    private func applyStrips(_ content: MangaDetailContent) {
        relatedAnimeContainerView.isHidden = content.relatedAnime.isEmpty
        relatedMangaContainerView.isHidden = content.relatedManga.isEmpty
        recommendationsContainerView.isHidden = content.recommendations.isEmpty

        mediaCollectionViews.forEach { $0.reloadData() }
    }

    private func setStripsHidden(_ isHidden: Bool) {
        relatedAnimeContainerView.isHidden = isHidden
        relatedMangaContainerView.isHidden = isHidden
        recommendationsContainerView.isHidden = isHidden
    }

    private func setSeeMoreTitle(isExpanded: Bool) {
        seeMoreButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        seeMoreButton.setTitle(isExpanded ? Strings.Detail.seeLess : Strings.Detail.seeMore, for: .normal)
    }

    // MARK: - Actions

    @IBAction private func seeMoreSynopsisButtonClicked(_ sender: UIButton) {
        let willExpand = synopsisTextViewHeight.constant <= Layout.collapsedSynopsisHeight
        synopsisTextViewHeight.constant = willExpand ? expandedSynopsisHeight : Layout.collapsedSynopsisHeight
        setSeeMoreTitle(isExpanded: willExpand)
    }

    @IBAction private func myListButtonClicked(_ sender: UIButton) {
        viewModel.openListSheet()
    }

    @IBAction private func seeMoreInfoButtonClicked(_ sender: UIButton) {
        viewModel.openCredits()
    }
}

// MARK: - Collection views

extension MangaDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genresCollectionView {
            return content?.genres.count ?? 0
        }
        return previews(for: collectionView).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionView != genresCollectionView else {
            let cell = collectionView.dequeue(GenreCollectionViewCell.self, for: indexPath)
            cell.configure(name: content?.genres[indexPath.item] ?? "")
            genresCollectionViewHeight.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
            return cell
        }

        let preview = previews(for: collectionView)[indexPath.item]
        switch preview.kind {
        case .anime:
            let cell = collectionView.dequeue(AnimeCollectionViewCell.self, for: indexPath)
            cell.configure(with: preview)
            return cell
        case .manga:
            let cell = collectionView.dequeue(MangaCollectionViewCell.self, for: indexPath)
            cell.configure(with: preview)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView != genresCollectionView else { return }
        viewModel.select(previews(for: collectionView)[indexPath.item])
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard collectionView != genresCollectionView else { return .zero }
        return CGSize(width: Layout.MediaCell.width, height: Layout.MediaCell.height)
    }

    private func previews(for collectionView: UICollectionView) -> [MediaPreview] {
        guard let content else { return [] }

        switch collectionView {
        case relatedAnimeCollectionView: return content.relatedAnime
        case relatedMangaCollectionView: return content.relatedManga
        case recommendationsCollectionView: return content.recommendations
        default: return []
        }
    }
}
