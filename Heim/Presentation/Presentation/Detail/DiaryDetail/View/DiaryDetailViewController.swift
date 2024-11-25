//
//  DiaryDetailViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Domain
import UIKit

final class DiaryDetailViewController: BaseViewController<DiaryDetailViewModel>, Coordinatable {
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
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    coordinator?.didFinish()
  }
  
  override func bindState() {
    super.bindState()
    
    // TODO: state를 통해 configure를 사용할 예정
    viewModel.$state
      .filter { !$0.isDeleted }
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] state in
        self?.contentView.configure(
          date: state.date,
          description: state.description,
          content: state.content
        )
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { $0.isDeleted }
      .filter { $0 }  // true인 경우만 처리
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.coordinator?.didFinish()
      }
      .store(in: &cancellable)
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
  
  @objc func deleteButtonTapped() {
    // MARK: - Alert창 생성
    let alertViewController = AlertViewController(
      title: "일기 삭제",
      message: "정말 삭제하시겠습니까?",
      leftButtonTitle: "다음에",
      rightbuttonTitle: "삭제"
    )
    
    alertViewController.setupLeftButtonAction { [weak self] in
      // 구현할 게 없습니다.
    }
    
    alertViewController.setupRightButtonAction { [weak self] in
      guard let self else { return }
      self.viewModel.action(.deleteDiary)
    }
    
    // MARK: - overFullScreen로 뒷 화면이 보이도록 설정
    alertViewController.modalPresentationStyle = .overFullScreen
    present(alertViewController, animated: false)
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
      coordinator?.pushHeimReplyView()
    case .replayVoice:
      coordinator?.pushDiaryReplayView()
    }
  }
}
