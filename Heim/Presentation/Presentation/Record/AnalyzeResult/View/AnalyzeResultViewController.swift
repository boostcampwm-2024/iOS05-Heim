//
//  AnalyzeResultView.swift
//  Presentation
//
//  Created by 박성근 on 11/27/24.
//

import Domain
import UIKit

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
          name: state.userName,
          description: state.description,
          content: state.content
        )
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { $0.isErrorPresent }
      .filter { $0 }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.presentAlert(
          type: .saveError,
          leftButtonAction: {
            self?.viewModel.action(.clearError)
          }
        )
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
      coordinator?.backToApproachView()
    }
  }
}
