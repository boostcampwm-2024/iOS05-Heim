//
//  AnalyzeResultView.swift
//  Presentation
//
//  Created by 박성근 on 11/27/24.
//

import Domain
import UIKit

// TODO: 이름을 불러오는 부분은 구현되지 않았습니다.
// Alertable의 경우 에러가 떴을 상황을 처리하기 위해 우선 채택하였습니다.
final class AnalyzeResultViewController: BaseViewController<AnalyzeResultViewModel>, Coordinatable, Alertable {
  // MARK: - UIComponents
  private let contentView = AnalyzeResultView()
  
  // MARK: - Properties
  weak var coordinator: DefaultAnalyzeResultCoordinator?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
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
    // coordinator?.didFinish()
  }
  
  override func bindState() {
    super.bindState()
    
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] state in
        self?.contentView.configure(
          description: state.description,
          content: state.content
        )
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { $0.isSaved }
      .filter { $0 }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.coordinator?.backToApproachView()
      }
      .store(in: &cancellable)
  }
}

extension AnalyzeResultViewController: AnalyzeResultViewDelegate {
  func buttonDidTap(
    _ recordingView: AnalyzeResultView,
    _ item: AnalyzeResultViewButtonItem
  ) {
    switch item {
    case .musicRecomendation:
      coordinator?.pushMusicRecommendationView()
    case .moveToHome:
      viewModel.action(.saveDiary)
    }
  }
}
