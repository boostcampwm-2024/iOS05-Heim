//
//  EmotionAnalyzeViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/23/24.
//

import Domain
import UIKit

final class EmotionAnalyzeViewController: BaseViewController<EmotionAnalyzeViewModel>, Coordinatable {
  // MARK: - UIComponents
  private let contentView = EmotionAnalyzeView()
  
  // MARK: - Properties
  weak var coordinator: DefaultEmotionAnalyzeRecordCoordinator?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
    contentView.delegate = self
    // TODO: setupNavigationBar()
    viewModel.action(.analyze)
  }
  
  override func setupViews() {
    super.setupViews()
    view.addSubview(contentView)
  }
  
  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // TODO: override func setupNavigationBar() { }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    coordinator?.didFinish()
  }
  
  override func bindState() {
    super.bindState()
    
    viewModel.$state
      .map(\.isAnalyzing)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isAnalyzing in
        self?.contentView.updatedescriptionLabel(isAnalyzing: isAnalyzing)
        self?.contentView.updateNextButton(isAnalyzing: isAnalyzing)
      }
      .store(in: &cancellable)
  }
}

extension EmotionAnalyzeViewController: EmotionAnalyzeViewDelegate {
  func buttonDidTap(_ emotionAnalyzeView: EmotionAnalyzeView) {
    // TODO: 분석 결과로 이동 (Diary를 보냄) -> diaryData()
  }
}
