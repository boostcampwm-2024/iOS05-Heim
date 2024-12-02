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
  weak var coordinator: DefaultEmotionAnalyzeCoordinator?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
    contentView.delegate = self
    setupNavigationBar()
    viewModel.action(.analyze)
  }
  
  deinit {
    coordinator?.didFinish()
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

private extension EmotionAnalyzeViewController {
  func setupNavigationBar() {
    self.navigationController?.navigationBar.isHidden = false
  }
}

extension EmotionAnalyzeViewController: EmotionAnalyzeViewDelegate {
  func buttonDidTap(_ emotionAnalyzeView: EmotionAnalyzeView) {
    let diary = viewModel.diaryData()
    coordinator?.pushDiaryReportView(diary: diary)
  }
}
