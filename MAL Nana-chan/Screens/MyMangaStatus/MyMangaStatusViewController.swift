//
//  MyMangaStatusViewController.swift
//  MAL Nana-chan
//

import UIKit

/// Bottom sheet for adding a manga to the user's list or editing its entry.
final class MyMangaStatusViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var readingButton: UIButton!
    @IBOutlet private weak var completedButton: UIButton!
    @IBOutlet private weak var onHoldButton: UIButton!
    @IBOutlet private weak var planToReadButton: UIButton!
    @IBOutlet private weak var droppedButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var moreDetailsButton: UIButton!
    @IBOutlet private weak var removeFromListButton: UIButton!

    @IBOutlet private weak var statusContentView: UIView!
    @IBOutlet private weak var moreAndRemoveView: UIStackView!

    @IBOutlet private weak var mangaTitleLabel: UILabel!
    @IBOutlet private weak var mangaStatusLabel: UILabel!
    @IBOutlet private weak var myStatusLabel: UILabel!
    @IBOutlet private weak var mangaChaptersNumLabel: UILabel!
    @IBOutlet private weak var mangaVolumesNumLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var priorityLabel: UILabel!

    @IBOutlet private weak var chaptersProgressView: UIProgressView!
    @IBOutlet private weak var volumesProgressView: UIProgressView!

    @IBOutlet private weak var scoreSlider: UISlider!
    @IBOutlet private weak var priorityPickerView: UIPickerView!

    // MARK: State

    var viewModel: MyMangaStatusViewModel!

    private var statusButtons: [UIButton] {
        [planToReadButton, completedButton, onHoldButton, readingButton, droppedButton]
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

        priorityPickerView.dataSource = self
        priorityPickerView.delegate = self

        moreDetailsButton.isHidden = true
    }

    private func assignStatusButtonTags() {
        planToReadButton.tag = UserMangaStatus.planToRead.buttonTag
        completedButton.tag = UserMangaStatus.completed.buttonTag
        onHoldButton.tag = UserMangaStatus.onHold.buttonTag
        readingButton.tag = UserMangaStatus.reading.buttonTag
        droppedButton.tag = UserMangaStatus.dropped.buttonTag
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

    private func render(_ state: ViewState<MyMangaStatusContent>) {
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

    private func apply(_ content: MyMangaStatusContent) {
        mangaTitleLabel.text = content.title
        mangaStatusLabel.text = content.mediaStatusText
        myStatusLabel.text = content.listStatusText
        mangaChaptersNumLabel.text = content.chaptersReadText
        mangaVolumesNumLabel.text = content.volumesReadText
        scoreLabel.text = content.scoreText
        priorityLabel.text = content.priorityText

        chaptersProgressView.setProgress(content.chaptersProgress, animated: false)
        volumesProgressView.setProgress(content.volumesProgress, animated: false)
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

    @IBAction private func scoreSliderChanged(_ sender: UISlider) {
        viewModel.setScore(Int(sender.value))
    }
}

// MARK: - Priority picker

extension MyMangaStatusViewController: UIPickerViewDataSource, UIPickerViewDelegate {

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
