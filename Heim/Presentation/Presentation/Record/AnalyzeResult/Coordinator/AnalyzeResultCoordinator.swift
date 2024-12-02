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
  func backToApproachView()
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
//    guard let defaultMusicMatchCoordinator = DIContainer.shared.resolve(type: MusicMatchCoordinator.self) else {
//      return
//    }
//    
//    addChildCoordinator(defaultMusicMatchCoordinator)
//    defaultMusicMatchCoordinator.parentCoordinator = self
//    defaultMusicMatchCoordinator.start()
  }
  
  public func backToApproachView() {
    parentCoordinator?.removeChild(self)
    parentCoordinator?.parentCoordinator?.removeChild(parentCoordinator)
    
    navigationController.dismiss(animated: true)
  }
}

// MARK: - Private
private extension DefaultAnalyzeResultCoordinator {
  func analyzeResultViewController(diary: Diary) -> AnalyzeResultViewController? {
    guard let diaryUseCase = DIContainer.shared.resolve(type: DiaryUseCase.self) else { return nil }
    guard let userUseCase = DIContainer.shared.resolve(type: UserUseCase.self) else { return nil }
    
    let viewModel = AnalyzeResultViewModel(
      diaryUseCase: diaryUseCase,
      userUseCase: userUseCase,
      diary: diary
    )
    let viewController = AnalyzeResultViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
