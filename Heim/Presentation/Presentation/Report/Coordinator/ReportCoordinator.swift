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
public protocol ReportCoordinator: Coordinator {}

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
  public func start() {
    guard let reportViewController = reportViewController() else { return }
    navigationController.pushViewController(reportViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  func reportViewController() -> ReportViewController? {
    guard let diaryUseCase = DIContainer.shared.resolve(type: DiaryUseCase.self) else {
      return nil
    }
    let viewModel = ReportViewModel(useCase: diaryUseCase)
    let reportViewController = ReportViewController(viewModel: viewModel)
    reportViewController.coordinator = self
    return reportViewController
  }
}
