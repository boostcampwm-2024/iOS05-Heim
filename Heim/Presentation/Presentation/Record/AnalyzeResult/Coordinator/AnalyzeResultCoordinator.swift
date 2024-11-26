//
//  AnalyzeResultCoordinator.swift
//  Presentation
//
//  Created by 박성근 on 11/27/24.
//

import Core
import Domain
import UIKit

public protocol AnalyzeResultCoordinator: Coordinator {
  func start(diary: Diary)
  func pushMusicRecommendationView()
  func pushHomeView()
}

public final class DefaultAnalyzeResultCoordinator: AnalyzeResultCoordinator {
  // MARK: - Properties
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController

  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  public func start() {}
  public func start(diary: Diary) {
    guard let analyzeResultViewController = analyzeResultViewController(diary: diary) else { return }
    navigationController.pushViewController(analyzeResultViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushMusicRecommendationView() {
    // TODO: 노래 추천으로 이동
  }
  
  public func pushHomeView() {
    // TODO: 홈 화면으로 이동
  }
}

// MARK: - Private
private extension DefaultAnalyzeResultCoordinator {
  func analyzeResultViewController(diary: Diary) -> AnalyzeResultViewController? {
    guard let analyzeResultUseCase = DIContainer.shared.resolve(type: AnalyzeResultUseCase.self) else { return nil }
    
    let viewModel = AnalyzeResultViewModel(useCase: analyzeResultUseCase, diary: diary)
    let viewController = AnalyzeResultViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
