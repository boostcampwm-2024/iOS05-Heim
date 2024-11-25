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
  func provideHomeViewController() -> HomeViewController
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
  
  public func provideHomeViewController() -> HomeViewController {
    guard let homeViewController = createHomeViewController() else { return HomeViewController() }
    return homeViewController
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushDiaryDetailView(diary: Diary) {
    guard let defaultDiaryDetailCoordinator = DIContainer.shared.resolve(type: DiaryDetailCoordinator.self) else {
      return
    }
    
    addChild(defaultDiaryDetailCoordinator)
    defaultDiaryDetailCoordinator.parentCoordinator = self
    defaultDiaryDetailCoordinator.start(diary: diary)
  }
  
  public func pushSettingView() {
    guard let defaultSettingCoordinator = DIContainer.shared.resolve(type: SettingCoordinator.self) else { return }
    
    addChild(defaultSettingCoordinator)
    defaultSettingCoordinator.parentCoordinator = self
    defaultSettingCoordinator.start()
  }
}

// MARK: - Private
private extension DefaultHomeCoordinator {
  func createHomeViewController() -> HomeViewController? {
    // TODO: 추후 도메인 모듈 주입 예정
    let viewController = HomeViewController()
    viewController.coordinator = self
    return viewController
  }
}
