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
          description: state.description,
          content: state.content
        )
      }
      .store(in: &cancellable)
  }
}

private extension AnalyzeResultViewController {
  func setupNavigationBar() {
    let backButton: UIButton = {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
      button.setImage(.backIcon, for: .normal)
      return button
    }()
    self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: backButton)
    self.navigationItem.backBarButtonItem?.tintColor = .white
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
