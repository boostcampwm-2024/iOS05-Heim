//
//  ReportCoordinator.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//

import Core
import Domain
import UIKit

//MARK: 수정 필요
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
    // TODO: 추후 사용
//    guard let diaryUseCase = DIContainer.shared.resolve(type: DiaryUseCase.self) else { return nil }
    
    let viewModel = ReportViewModel()
    let viewController = ReportViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
