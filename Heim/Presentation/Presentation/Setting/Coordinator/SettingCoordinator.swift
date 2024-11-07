//
//  SettingCoordinator.swift
//  Presentation
//
//  Created by 한상진 on 11/7/24.
//

import Core
import Domain
import UIKit

public protocol SettingCoordinator: Coordinator {
  func pushQuestionWebView()
}

public final class DefaultSettingCoordinator: SettingCoordinator {
  
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
    guard let settingViewController = settingViewController() else { return }
    navigationController.pushViewController(settingViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  public func pushQuestionWebView() {
    // TODO: '문의하기' 관련 구글폼 웹 뷰 연결 예정
  }
}

// MARK: - Private
private extension DefaultSettingCoordinator {
  func settingViewController() -> SettingViewController? {
    guard let settingUseCase = DIContainer.shared.resolve(type: SettingUseCase.self) else { return nil }
    
    let viewModel = SettingViewModel(useCase: settingUseCase)
    let viewController = SettingViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
