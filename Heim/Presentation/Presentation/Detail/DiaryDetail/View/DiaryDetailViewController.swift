//
//  DiaryDetailViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Domain
import UIKit

final class DiaryDetailViewController: BaseViewController<DiaryDetailViewModel>, Coordinatable, Alertable {
  // MARK: - UIComponents
  private let contentView = DiaryDetailView()
  
  // MARK: - Properties
  weak var coordinator: DefaultDiaryDetailCoordinator?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
    setupNavigationBar()
    viewModel.action(.fetchDiary)
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
  
  deinit {
    coordinator?.didFinish()
  }
  
  override func bindState() {
    super.bindState()
    
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] state in
        self?.contentView.configure(
          date: state.calendarDate,
          description: state.description,
          content: state.content
        )
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { $0.isDeleted }
      .filter { $0 }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.coordinator?.didFinish()
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { $0.isErrorPresent }
      .filter { $0 }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.presentAlert(
          type: .deleteError,
          leftButtonAction: { }
        )
      }
      .store(in: &cancellable)
  }
  
  @objc
  func deleteButtonTapped() {
    presentAlert(
      type: .removeDiary,
      leftButtonAction: {},
      rightButtonAction: { [weak self] in
        self?.viewModel.action(.deleteDiary)
      }
    )
  }
}

private extension DiaryDetailViewController {
  func setupNavigationBar() {
    let deleteButton: UIButton = {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
      button.setImage(.trashIcon, for: .normal)
      button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
      return button
    }()
    deleteButton.tintColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
  }
}

extension DiaryDetailViewController: DiaryDetailViewDelegate {
  func buttonDidTap(
    _ recordingView: DiaryDetailView,
    _ item: DiaryDetailViewButtonItem
  ) {
    switch item {
    case .musicRecomendation:
      coordinator?.pushMusicRecommendationView()
    case .heimReply:
      coordinator?.pushHeimReplyView(diary: viewModel.diary)
    case .replayVoice:
      coordinator?.pushDiaryReplayView(diary: viewModel.diary, userName: viewModel.userName)
    }
  }
}
