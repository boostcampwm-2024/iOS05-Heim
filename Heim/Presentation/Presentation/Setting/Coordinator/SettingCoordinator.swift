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
  func openQuestionURL()
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
  
  public func openQuestionURL() {
    // TODO: WKWebView로 전환할 예정
    guard let url = URL(string: "https://docs.google.com/forms/d/1OsrcQcyhgRW6uJT5tVADGMK9cW66K70i0bQVKjCSydY") else {
      return
    }
    
    // TODO: 에러 처리
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:])
    }
  }
}

// MARK: - Private
private extension DefaultSettingCoordinator{
  func settingViewController() -> SettingViewController? {
    guard let settingUseCase = DIContainer.shared.resolve(type: SettingUseCase.self) else { return nil }
    
    let viewModel = SettingViewModel(useCase: settingUseCase)
    let viewController = SettingViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
