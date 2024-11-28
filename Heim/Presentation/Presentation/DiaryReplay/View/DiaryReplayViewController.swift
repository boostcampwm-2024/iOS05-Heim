//
//  DiaryReplayViewController.swift
//  Presentation
//
//  Created by 정지용 on 11/28/24.
//

import Domain
import UIKit

final class DiaryReplayViewController: BaseViewController<DiaryReplayViewModel> {
  // MARK: - UIComponents
  private let visualizerView = VisualizerView()
  private lazy var contentView = DiaryReplayView(visualizerView: visualizerView)
  var diary: Diary
  
  // MARK: - Initiaizer
  init(
    viewModel: DiaryReplayViewModel,
    diary: Diary
  ) {
    self.diary = diary
    super.init(viewModel: viewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupActions()
  }
  
  override func setupViews() {
    super.setupViews()
    contentView.delegate = self
    view.addSubview(contentView)
  }
  
  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func bindState() {
    viewModel.$state
      .map(\.isPlaying)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isPlaying in
        self?.contentView.updatePlayButtonImage(isPlaying: isPlaying)
        if isPlaying {
          self?.viewModel.startTimeObservation()
          self?.visualizerView.startVisualizer(for: self?.viewModel)
        } else {
          self?.viewModel.stopTimeObservation()
          self?.visualizerView.stopVisualizer()
        }
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map(\.currentTime)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] timeText in
        self?.contentView.updateTimeLabel(text: timeText)
      }
      .store(in: &cancellable)
  }
  
  private func setupActions() {
    if let audioData = loadAudioData() {
      viewModel.action(.updateState(data: audioData))
    }
  }
  
  private func loadAudioData() -> Data? {
    return diary.voice.audioBuffer
  }
}

extension DiaryReplayViewController: DiaryReplayViewDelegate {
  func buttonDidTap(
    _ diaryReplayView: DiaryReplayView,
    _ item: DiaryReplayViewButtonItem
  ) {
    switch item {
    case .replayToggle:
      viewModel.action(
        viewModel.state.isPlaying ? .pause : .play
      )
    case .refresh:
      viewModel.action(.reset)
    }
  }
}
