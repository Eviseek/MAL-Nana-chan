//
//  MyAnimeStatusViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Bottom sheet for adding an anime to the user's list or editing its entry.
final class MyAnimeStatusViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var planToWatchButton: UIButton!
    @IBOutlet private weak var completedButton: UIButton!
    @IBOutlet private weak var onHoldButton: UIButton!
    @IBOutlet private weak var watchingButton: UIButton!
    @IBOutlet private weak var droppedButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var moreDetailsButton: UIButton!
    @IBOutlet private weak var removeFromListButton: UIButton!

    @IBOutlet private weak var statusContentView: UIView!
    @IBOutlet private weak var moreAndRemoveView: UIStackView!

    @IBOutlet private weak var animeTitleLabel: UILabel!
    @IBOutlet private weak var animeStatusLabel: UILabel!
    @IBOutlet private weak var myAnimeStatusLabel: UILabel!
    @IBOutlet private weak var itemEpisodesNumLabel: UILabel!
    @IBOutlet private weak var itemEpisodesWatchedLabel: UILabel!
    @IBOutlet private weak var priorityLabel: UILabel!
    @IBOutlet private weak var itemScoreLabel: UILabel!

    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var scoreSlider: UISlider!
    @IBOutlet private weak var priorityPicker: UIPickerView!

    // MARK: State

    var viewModel: MyAnimeStatusViewModel!

    /// All five status buttons, so selection can be applied in one pass.
    private var statusButtons: [UIButton] {
        [planToWatchButton, completedButton, onHoldButton, watchingButton, droppedButton]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        bindViewModel()
        viewModel.onViewDidLoad()
    }

    // MARK: - Set-up

    private func setUpViews() {
        (statusButtons + [removeFromListButton, moreDetailsButton]).forEach { $0.round() }

        assignStatusButtonTags()

        scoreSlider.minimumValue = Layout.Score.minimum
        scoreSlider.maximumValue = Layout.Score.maximum

        priorityPicker.dataSource = self
        priorityPicker.delegate = self

        moreDetailsButton.isHidden = true
    }

    /// The sheet finds its buttons through `viewWithTag`, so each has to carry the
    /// tag its status maps to.
    private func assignStatusButtonTags() {
        planToWatchButton.tag = UserAnimeStatus.planToWatch.buttonTag
        completedButton.tag = UserAnimeStatus.completed.buttonTag
        onHoldButton.tag = UserAnimeStatus.onHold.buttonTag
        watchingButton.tag = UserAnimeStatus.watching.buttonTag
        droppedButton.tag = UserAnimeStatus.dropped.buttonTag
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
        viewModel.onShowMessage = { [weak self] message in
            self?.showErrorDialog(message: message)
        }
        viewModel.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    // MARK: - Rendering

    private func render(_ state: ViewState<MyAnimeStatusContent>) {
        switch state {
        case .loading:
            SkeletonPresenter.show(on: view)

        case .content(let content):
            SkeletonPresenter.hide(on: view)
            apply(content)

        case .empty(let message), .failure(let message):
            SkeletonPresenter.hide(on: view)
            showErrorDialog(message: message)
        }
    }

    private func apply(_ content: MyAnimeStatusContent) {
        animeTitleLabel.text = content.title
        animeStatusLabel.text = content.mediaStatusText
        myAnimeStatusLabel.text = content.listStatusText
        itemEpisodesWatchedLabel.text = content.episodesWatchedText
        itemEpisodesNumLabel.text = content.totalEpisodesText
        itemScoreLabel.text = content.scoreText
        priorityLabel.text = content.priorityText

        progressBar.progress = content.progress
        scoreSlider.value = content.score

        saveButton.setTitle(content.saveButtonTitle, for: .normal)
        moreAndRemoveView.isHidden = !content.canRemove

        statusButtons.forEach { $0.setStatusSelected($0.tag == content.selectedStatus.buttonTag) }
    }

    // MARK: - Actions

    @IBAction private func buttonSelected(_ sender: UIButton) {
        viewModel.selectStatus(buttonTag: sender.tag)
    }

    @IBAction private func saveClicked(_ sender: UIButton) {
        viewModel.save()
    }

    @IBAction private func cancelClicked(_ sender: UIButton) {
        viewModel.cancel()
    }

    @IBAction private func removeClicked(_ sender: UIButton) {
        viewModel.remove()
    }

    @IBAction private func moreDetailsClicked(_ sender: UIButton) {
        // Intentionally empty: the button is hidden until there is a screen to open.
    }

    @IBAction private func scoreSliderValueChanged(_ sender: UISlider) {
        viewModel.setScore(Int(sender.value))
    }
}

// MARK: - Priority picker

extension MyAnimeStatusViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.priorities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.priorities[row].displayName
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectPriority(at: row)
    }
}
