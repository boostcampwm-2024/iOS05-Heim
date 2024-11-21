//
//  RecordViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import Domain
import UIKit

final class RecordViewController: BaseViewController<RecordViewModel>, Coordinatable {
  // MARK: - UIComponents
  private let contentView = RecordView()
  
  // MARK: - Properties
  weak var coordinator: DefaultRecordCoordinator?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    Task {
      await viewModel.setup()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
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
    super.bindState()
    
    // 녹음 상태
    viewModel.$state
      .map(\.isRecording)
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] isRecording in
        self?.contentView.updatePlayButtonImage(isPlaying: isRecording)
      }
      .store(in: &cancellable)
    
    // 시간 텍스트
    viewModel.$state
      .map(\.timeText)
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] timeText in
        self?.contentView.updateTimeLabel(text: timeText)
      }
      .store(in: &cancellable)
    
    // 다음 버튼
    viewModel.$state
      .map { state in
        !state.isRecording && state.canMoveToNext
      }
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] isEnabled in
        self?.contentView.updateNextButton(isEnabled: isEnabled)
      }
      .store(in: &cancellable)
  }
}

extension RecordViewController: RecordViewDelegate {
  func buttonDidTap(
    _ recordingView: RecordView,
    _ item: RecordViewButtonItem
  ) {
    switch item {
    case .recordToggle:
      viewModel.action(
        viewModel.state.isRecording ? .stopRecording : .startRecording
      )
    case .refresh:
      viewModel.action(.refresh)
    case .next:
      viewModel.action(.moveToNext)
    case .close:
      // TODO: 추후 화면 연결시 동작 확인 필요
      coordinator?.didFinish()
    }
  }
}
