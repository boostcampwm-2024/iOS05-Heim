//
//  HomeCoordinator.swift
//  Presentation
//
//  Created by 한상진 on 11/21/24.
//

import Core
import Domain
import UIKit

public protocol HomeCoordinator: Coordinator {
  func provideHomeViewController() -> HomeViewController?
  func pushDiaryDetailView(diary: Diary)
  func pushSettingView()
}

public final class DefaultHomeCoordinator: HomeCoordinator {
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
    guard let homeViewController = createHomeViewController() else { return }
    navigationController.pushViewController(homeViewController, animated: true)
  }
  
  public func provideHomeViewController() -> HomeViewController? {
    guard let homeViewController = createHomeViewController() else { return nil }
    return homeViewController
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushDiaryDetailView(diary: Diary) {
    guard let defaultDiaryDetailCoordinator = DIContainer.shared.resolve(type: DiaryDetailCoordinator.self) else {
      return
    }
    
    addChildCoordinator(defaultDiaryDetailCoordinator)
    defaultDiaryDetailCoordinator.parentCoordinator = self
    defaultDiaryDetailCoordinator.start(diary: diary)
  }
  
  public func pushSettingView() {
    guard let defaultSettingCoordinator = DIContainer.shared.resolve(type: SettingCoordinator.self) else { return }
    
    addChildCoordinator(defaultSettingCoordinator)
    defaultSettingCoordinator.parentCoordinator = self
    defaultSettingCoordinator.start()
  }
}

// MARK: - Private
private extension DefaultHomeCoordinator {
  func createHomeViewController() -> HomeViewController? {
    guard let diaryUseCase = DIContainer.shared.resolve(type: DiaryUseCase.self) else { return nil }
    
    let viewModel = HomeViewModel(useCase: diaryUseCase)
    let viewController = HomeViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
