//
//  AnimeDetailViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Full details for one anime.
final class AnimeDetailViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorMsgLabel: UILabel!

    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var episodesLabel: UILabel!
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var synonymsListLabel: UILabel!
    @IBOutlet private weak var englishListLabel: UILabel!
    @IBOutlet private weak var japaneseListLabel: UILabel!

    @IBOutlet private weak var mainImageImageView: UIImageView!
    @IBOutlet private weak var synopsisTextView: UITextView!

    @IBOutlet private weak var genreCollectionView: UICollectionView!
    @IBOutlet private weak var relatedAnimeCollectionView: UICollectionView!
    @IBOutlet private weak var relatedMangaCollectionView: UICollectionView!
    @IBOutlet private weak var recommendationsCollectionView: UICollectionView!

    @IBOutlet private weak var relatedAnimeContainerView: UIView!
    @IBOutlet private weak var relatedMangaContainerView: UIView!
    @IBOutlet private weak var recommendationsContainerView: UIView!

    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    /// Connected by the storyboard but never adjusted — the genre strip spans the
    /// full width. Kept so the storyboard's outlet still resolves.
    @IBOutlet private weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var relatedAnimeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var relatedMangaCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var recommendationsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var synopsisTextViewHeight: NSLayoutConstraint!

    @IBOutlet private weak var seeMoreButton: UIButton!
    @IBOutlet private weak var myListButton: UIButton!

    // MARK: State

    var viewModel: AnimeDetailViewModel!
    var coordinator: MediaCoordinator?

    private let loadingIndicator = LoadingIndicator()
    private var content: AnimeDetailContent?

    /// Full height of the synopsis, remembered so "see more" can expand to it.
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
        myListButton.isHidden = !viewModel.isSignedIn

        genreCollectionView.register(GenreCollectionViewCell.self)
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self

        // All three strips show anime *and* manga posters, so all three register
        // both cell types. The old code registered only the anime cell but
        // dequeued the manga identifier for the related-manga strip, which is an
        // unregistered-identifier exception — a hard crash on any anime with
        // related manga.
        for strip in mediaCollectionViews {
            strip.register(AnimeCollectionViewCell.self)
            strip.register(MangaCollectionViewCell.self)
            strip.dataSource = self
            strip.delegate = self
        }

        relatedAnimeCollectionViewHeight.constant = Layout.MediaCell.height
        relatedMangaCollectionViewHeight.constant = Layout.MediaCell.height
        recommendationsCollectionViewHeight.constant = Layout.MediaCell.height
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
        viewModel.onOpenThemes = { [weak self] animeID in
            self?.coordinator?.showThemes(animeID: animeID)
        }
        viewModel.onOpenCredits = { [weak self] animeID in
            self?.coordinator?.showAnimeCredits(animeID: animeID)
        }
        viewModel.onOpenListSheet = { [weak self] target in
            self?.coordinator?.presentListSheet(for: target)
        }
    }

    // MARK: - Rendering

    private func render(_ state: ViewState<AnimeDetailContent>) {
        switch state {
        case .loading:
            loadingIndicator.start(in: view)

        case .content(let content):
            loadingIndicator.stop()
            self.content = content
            scrollView.isHidden = false
            errorView.isHidden = true
            apply(content)

        case .empty(let message), .failure(let message):
            loadingIndicator.stop()
            content = nil
            scrollView.isHidden = true
            errorView.isHidden = false
            errorMsgLabel.text = message
        }
    }

    /// Split into three, because "fill in the header", "lay out the synopsis" and
    /// "reload the strips" fail and change for entirely different reasons.
    private func apply(_ content: AnimeDetailContent) {
        applyHeader(content)
        applySynopsis(content.synopsis)
        applyStrips(content)
    }

    private func applyHeader(_ content: AnimeDetailContent) {
        itemNameLabel.text = content.title
        scoreLabel.text = content.scoreText
        typeLabel.text = content.typeText
        statusLabel.text = content.statusText
        episodesLabel.text = content.episodesText
        durationLabel.text = content.durationText
        seasonLabel.text = content.seasonText
        mainImageImageView.setRemoteImage(content.imageURL)

        // Left as the nib's placeholder when absent, matching the previous
        // behaviour of only assigning non-empty values.
        if let synonymsText = content.synonymsText { synonymsListLabel.text = synonymsText }
        if let englishTitle = content.englishTitle { englishListLabel.text = englishTitle }
        if let japaneseTitle = content.japaneseTitle { japaneseListLabel.text = japaneseTitle }

        genreCollectionView.reloadData()
    }

    private func applySynopsis(_ synopsis: String) {
        synopsisTextView.text = synopsis
        synopsisTextView.sizeToFit()

        expandedSynopsisHeight = synopsisTextView.contentSize.height

        let fitsWithoutExpanding = expandedSynopsisHeight < Layout.collapsedSynopsisHeight
        synopsisTextViewHeight.constant = fitsWithoutExpanding
            ? expandedSynopsisHeight
            : Layout.collapsedSynopsisHeight
        // Hidden rather than `removeFromSuperview()`: removal is irreversible, so
        // a second render (a retry, or a reload after a list edit) could never get
        // the button back.
        seeMoreButton.isHidden = fitsWithoutExpanding
        setSeeMoreTitle(isExpanded: false)
    }

    private func applyStrips(_ content: AnimeDetailContent) {
        relatedAnimeContainerView.isHidden = content.relatedAnime.isEmpty
        relatedMangaContainerView.isHidden = content.relatedManga.isEmpty
        recommendationsContainerView.isHidden = content.recommendations.isEmpty

        mediaCollectionViews.forEach { $0.reloadData() }
    }

    private func setSeeMoreTitle(isExpanded: Bool) {
        seeMoreButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        seeMoreButton.setTitle(isExpanded ? Strings.Detail.seeLess : Strings.Detail.seeMore, for: .normal)
    }

    // MARK: - Actions

    @IBAction private func openOpeningsAndEndings(_ sender: UIButton) {
        viewModel.openThemes()
    }

    @IBAction private func openMoreInformation(_ sender: UIButton) {
        viewModel.openCredits()
    }

    @IBAction private func addToList(_ sender: UIButton) {
        viewModel.openListSheet()
    }

    @IBAction private func seeMoreSynopsisButton(_ sender: UIButton) {
        let willExpand = synopsisTextViewHeight.constant <= Layout.collapsedSynopsisHeight
        synopsisTextViewHeight.constant = willExpand ? expandedSynopsisHeight : Layout.collapsedSynopsisHeight
        setSeeMoreTitle(isExpanded: willExpand)
    }

    @IBAction private func tryAgainButtonClicked(_ sender: UIButton) {
        viewModel.onRetryTapped()
    }
}

// MARK: - Collection views

extension AnimeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView {
            return content?.genres.count ?? 0
        }
        return previews(for: collectionView).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionView != genreCollectionView else {
            let cell = collectionView.dequeue(GenreCollectionViewCell.self, for: indexPath)
            cell.configure(name: content?.genres[indexPath.item] ?? "")
            // The genre pills wrap, so the strip's height depends on its content.
            collectionViewHeight.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
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
        guard collectionView != genreCollectionView else { return }
        viewModel.select(previews(for: collectionView)[indexPath.item])
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard collectionView != genreCollectionView else { return .zero }
        return CGSize(width: Layout.MediaCell.width, height: Layout.MediaCell.height)
    }

    /// Which list of posters a given strip shows.
    ///
    /// One lookup instead of the four `if collectionView == …` chains that the
    /// data source, the delegate and the sizing method each repeated.
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
