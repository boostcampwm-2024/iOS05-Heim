//
//  DiaryDetailCoordinator.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Core
import Domain
import UIKit

public protocol DiaryDetailCoordinator: Coordinator {
  // MARK: - 추천음악 감상하기로 이동
  func pushMusicRecommendationView()
  // MARK: - 하임이의 답장 보러가기 이동
  func pushHeimReplyView()
  // MARK: - 나의 이야기 다시듣기 이동
  func pushDiaryReplayView()
}

public final class DefaultDiaryDetailCoordinator: DiaryDetailCoordinator {
  // MARK: - Properties
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController

  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  public func start() {
//    guard let diaryDetailViewController = diaryDetailViewController(date: String) else { return }
//    navigationController.pushViewController(diaryDetailViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushMusicRecommendationView() {
    <#code#>
  }
  
  public func pushHeimReplyView() {
    <#code#>
  }
  
  public func pushDiaryReplayView() {
    <#code#>
  }
  
}

// MARK: - Private
private extension DefaultDiaryDetailCoordinator {
//  func diaryDetailViewController() -> SettingViewController? {
//    guard let settingUseCase = DIContainer.shared.resolve(type: SettingUseCase.self) else { return nil }
//    
//    let viewModel = SettingViewModel(useCase: settingUseCase)
//    let viewController = SettingViewController(viewModel: viewModel)
//    viewController.coordinator = self
//    return viewController
//  }
}
