//
//  ReportCoordinator.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//

import Core
import Domain
import UIKit

public protocol ReportCoordinator: Coordinator {
  func provideReportViewController() -> ReportViewController?
}

public final class DefaultReportCoordinator: ReportCoordinator {
  // MARK: - Properties
  public var parentCoordinator: (any Coordinator)?
  public var childCoordinators: [any Coordinator] = []
  public var navigationController: UINavigationController

  // MARK: - Initializer
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  public func start() {}
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  public func provideReportViewController() -> ReportViewController? {
    guard let reportViewController = createReportViewController() else { return nil }
    return reportViewController
  }
}

private extension DefaultReportCoordinator {
  func createReportViewController() -> ReportViewController? {
    guard let userUseCase = DIContainer.shared.resolve(type: UserUseCase.self) else { return nil }
    guard let diaryUseCase = DIContainer.shared.resolve(type: DiaryUseCase.self) else { return nil }
    
    let viewModel = ReportViewModel(userUseCase: userUseCase, diaryUseCase: diaryUseCase)
    let viewController = ReportViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
